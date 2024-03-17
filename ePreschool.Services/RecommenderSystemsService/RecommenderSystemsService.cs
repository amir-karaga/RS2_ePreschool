using ePreschool.Core.Models;
using ePreschool.Infrastructure.UnitOfWork;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System.Data;

namespace ePreschool.Services
{
    public class RecommenderSystemsService : IRecommenderSystemsService
    {
        private readonly UnitOfWork _unitOfWork;
        static readonly SemaphoreSlim semaphore = new SemaphoreSlim(1, 1);
        private static MLContext mlContext;
        private static ITransformer model;

        public RecommenderSystemsService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
        }

        public async Task<List<EntityItemModel>> RecommendEmployeesAsync(int companyId, int parentReviewerId)
        {
            try
            {
                await semaphore.WaitAsync();

                var reviewsByCompany = _unitOfWork.EmployeeReviewsRepository.GetByPrechoolId(companyId);
                var employees = await _unitOfWork.EmployeesRepository.GetEntityItemModelsByCompanyId(companyId);

                if (!reviewsByCompany.Any())
                {
                    return employees;
                }

                var data = reviewsByCompany.Select(x => new EmployeeRating()
                {
                    ParentReviewerId = (uint)x.ParentReviewerId,
                    EmployeeId = (uint)x.EmployeeId,
                    Label = x.ReviewRating
                });

                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var traindata = mlContext.Data.LoadFromEnumerable(data);

                    var options = new MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = "ParentReviewerIdEncoded",
                        MatrixRowIndexColumnName = "EmployeeIdEncoded",
                        LabelColumnName = "Label",
                        NumberOfIterations = 20,
                        ApproximationRank = 100
                    };

                    var pipeline = mlContext.Transforms.Conversion.MapValueToKey(
                            inputColumnName: "ParentReviewerId",
                            outputColumnName: "ParentReviewerIdEncoded")
                        .Append(mlContext.Transforms.Conversion.MapValueToKey(
                            inputColumnName: "EmployeeId",
                            outputColumnName: "EmployeeIdEncoded")
                        .Append(mlContext.Recommendation().Trainers.MatrixFactorization(options)));

                    model = pipeline.Fit(traindata);
                }

                var predictionEngine = mlContext.Model.CreatePredictionEngine<EmployeeRating, EmployeeRatingPrediction>(model);

                var top5 = (from e in employees
                            let p = predictionEngine.Predict(
                               new EmployeeRating()
                               {
                                   ParentReviewerId = (uint)parentReviewerId,
                                   EmployeeId = (uint)e.Id,
                               })
                            orderby p.Label descending
                            select (EmployeeId: e.Id, EmployeeFullName: e.Label, Score: p.Score)).Take(5);
                return top5.Select(x => new EntityItemModel() { Id = x.EmployeeId, Label = x.EmployeeFullName }).ToList();
            }
            catch (Exception)
            {
                mlContext = null;
                return new List<EntityItemModel> { };
            }
            finally
            {
                semaphore.Release();
            }

        }

        public class EmployeeRating
        {
            [KeyType(count: 10)]
            public uint ParentReviewerId { get; set; }
            [KeyType(count: 10)]
            public uint EmployeeId { get; set; }
            public float Label { get; set; }
        }

        public class EmployeeRatingPrediction
        {
            public float Label { get; set; }
            public float Score { get; set; }
        }
    }
}