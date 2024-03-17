using EasyNetQ;
using ePreschool.Shared.Models;
using ePreschool.Shared.Services.Email;
using Microsoft.Extensions.Configuration;

class Program
{
    private readonly IEmail _email;

    public Program(IEmail email)
    {
        _email = email;
    }
    static async Task Main(string[] args)
    {
        IConfiguration configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
            .Build();

        configuration[]
        using (var bus = RabbitHutch.CreateBus("host=localhost"))
        {
            bus.PubSub.Subscribe<EmailModel>("email_send", async email =>
            {
                var program = new Program(new Email(configuration));
                await program._email.Send(email.Title, email.Body, email.Email);
                Console.WriteLine($"Received: {email?.Email}");
            });
            Console.ReadLine();
        }
    }
}
