﻿namespace ePreschool.Services
{
    public interface IRabbitMQProducer
    {
        public void SendMessage<T>(T message);
    }
}

