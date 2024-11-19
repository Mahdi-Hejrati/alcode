<%! 
import filters.csharp as filters
%>
% for fd in root.federates.values(): 
/*
<%include file="/header.makot" args="root=root"/>
*/

using System;
using System.Text;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;

public class Connection_Almas
{
    private readonly IDictionary<string, string> _config;
    private IConnection _subConnection;
    private IModel _subChannel;
    private string _subQueueName;

    private IConnection _pubConnection;
    private IModel _pubChannel;

    public Connection_Almas(IDictionary<string, string> config)
    {
        _config = config;

        var factory = new ConnectionFactory
        {
            HostName = _config["host"],
            Port = int.Parse(_config["port"]),
            UserName = _config["login"],
            Password = _config["passw"]
        };

        _subConnection = factory.CreateConnection();
        _subChannel = _subConnection.CreateModel();
        _subQueueName = _subChannel.QueueDeclare().QueueName;

        _pubConnection = factory.CreateConnection();
        _pubChannel = _pubConnection.CreateModel();
    }

    public void DoSubscribe(string topic)
    {
        _subChannel.ExchangeDeclare(exchange: topic, type: ExchangeType.Topic);
        _subChannel.QueueBind(queue: _subQueueName, exchange: topic, routingKey: topic);
    }

    public void DoPublish(string topic)
    {
        _pubChannel.ExchangeDeclare(exchange: topic, type: ExchangeType.Topic);
    }

    public void Publish(string topic, string serialized)
    {
        var body = Encoding.UTF8.GetBytes(serialized);
        _pubChannel.BasicPublish(exchange: topic, routingKey: topic, basicProperties: null, body: body);
    }

    public Thread Start()
    {
        var thread = new Thread(Receiving) { IsBackground = true };
        thread.Start();
        return thread;
    }

    private void Receiving()
    {
        var consumer = new EventingBasicConsumer(_subChannel);
        consumer.Received += (model, ea) =>
        {
            var body = ea.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);
            Callback(ea.RoutingKey, message);
        };
        _subChannel.BasicConsume(queue: _subQueueName, autoAck: true, consumer: consumer);
    }

    protected virtual void Callback(string routingKey, string message)
    {
        Receive(routingKey, message);
    }

    public virtual void Receive(string topic, string value)
    {
        // Implement your receive logic here
    }
}

ALMAS-FILE-INFO
rabbitmq/csharp/${fd.name|filters.cap}/Core/Protocol.cs
ALMAS-FILE-SEPRATE
% endfor

