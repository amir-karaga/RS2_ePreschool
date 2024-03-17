namespace ePreschool.Shared.Constants
{
    public class EmailMessages
    {
        public const string ResetPasswordSubject = "Lahor Team | Resetovanje lozinke";
        public const string ConfirmationEmailSubject = "Lahor Team | Dodjela korisničkog naloga";
        public const string ClientEmailSubject = "Lahor Team | Dodjela uloge klijenta";
        public static string GeneratePasswordEmail(string name, string password)
        {
            string message = $"Poštovani {name}, </br> Uspješno je kreiran račun na aplikaciji <span style='font-style:italic'>ePreschool</span>. </br> Vaš privremeni password je:<h4 style='color:blue'> {password} </h4></br> Uživajte u korištenju naše aplikacije. </br> Lijep pozdrav,</br> <span style='font-style: italic'>ePreschool Team</span>";
            return message;
        }

    }
}
