using AutoMapper;
using ePreschool.Core;
using ePreschool.Core.Entities.Base;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public abstract class BaseService<TEntity, TModel, TUpsertModel, TSearchObject, TRepository> : IBaseService<int, TModel, TUpsertModel, TSearchObject>
        where TEntity : BaseEntity
        where TModel : BaseModel
        where TUpsertModel : BaseUpsertModel
        where TSearchObject : BaseSearchObject
        where TRepository : class, IBaseRepository<TEntity, int, TSearchObject>
    {
        private const bool ShouldSoftDelete = true;

        protected readonly IMapper Mapper;
        protected readonly UnitOfWork UnitOfWork;
        protected readonly TRepository CurrentRepository;
        protected readonly IValidator<TUpsertModel> Validator;

        protected BaseService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<TUpsertModel> validator)
        {
            Mapper = mapper;
            UnitOfWork = (UnitOfWork)unitOfWork;
            Validator = validator;
            var fieldInfo = unitOfWork.GetType()
                            .GetFields()
                            .FirstOrDefault(f => f.FieldType == typeof(TRepository));

            if (fieldInfo != null)
            {
                CurrentRepository = (TRepository)fieldInfo.GetValue(unitOfWork)!;
            }
            else
            {
                // Dodajte dodatnu logiku ili bacite izuzetak ako ne možete pronaći CurrentRepository.
                throw new InvalidOperationException($"Repository of type {typeof(TRepository)} not found in UnitOfWork.");
            }
        }

        public virtual async Task<TModel?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await CurrentRepository.GetByIdAsync(id, cancellationToken);
            return Mapper.Map<TModel>(entity);
        }


        public virtual async Task<PagedList<TModel>> GetPagedAsync(TSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            try
            {
                var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
                return Mapper.Map<PagedList<TModel>>(pagedList);

            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public virtual async Task<TModel> AddAsync(TUpsertModel model, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(model, cancellationToken);

            var entity = Mapper.Map<TEntity>(model);
            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<TModel>(entity);
        }

        public virtual async Task<IEnumerable<TModel>> AddRangeAsync(IEnumerable<TUpsertModel> models, CancellationToken cancellationToken = default)
        {
            await ValidateRangeAsync(models, cancellationToken);

            var entities = Mapper.Map<IEnumerable<TEntity>>(models);
            await CurrentRepository.AddRangeAsync(entities, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<IEnumerable<TModel>>(entities);
        }

        public virtual async Task<TModel> UpdateAsync(TUpsertModel model, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(model, cancellationToken);

            var entity = Mapper.Map<TEntity>(model);
            CurrentRepository.Update(entity);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<TModel>(entity);
        }

        public virtual async Task<IEnumerable<TModel>> UpdateRangeAsync(IEnumerable<TUpsertModel> models, CancellationToken cancellationToken = default)
        {
            await ValidateRangeAsync(models, cancellationToken);

            var entities = Mapper.Map<IEnumerable<TEntity>>(models);
            CurrentRepository.UpdateRange(entities);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<IEnumerable<TModel>>(entities);
        }

        public virtual async Task RemoveAsync(TModel model, CancellationToken cancellationToken = default)
        {
            var entity = Mapper.Map<TEntity>(model);
            CurrentRepository.Remove(entity);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
        }

        public virtual async Task RemoveByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            await CurrentRepository.RemoveByIdAsync(id, ShouldSoftDelete, cancellationToken);
        }

        protected async Task ValidateAsync(TUpsertModel model, CancellationToken cancellationToken = default)
        {
            var validationResult = await Validator.ValidateAsync(model, cancellationToken);
            if (validationResult.IsValid == false)
            {
                throw new Core.ValidationException(Mapper.Map<List<ValidationError>>(validationResult.Errors));
            }

        }

        protected async Task ValidateRangeAsync(IEnumerable<TUpsertModel> models, CancellationToken cancellationToken = default)
        {
            foreach (var model in models)
            {
                await ValidateAsync(model, cancellationToken);
            }
        }

    }
}
