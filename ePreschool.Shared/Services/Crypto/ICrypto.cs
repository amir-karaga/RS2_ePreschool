
namespace ePreschool.Shared.Services.Crypto
{
    public interface ICrypto
    {
        string GenerateHash(string input, string salt);
        string GenerateSalt();
        bool Verify(string hash, string salt, string input);
        string GeneratePassword(int length = 8);
    }
}
