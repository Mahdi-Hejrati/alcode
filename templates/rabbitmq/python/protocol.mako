<%! 
import filters.python as filters
%>
% for fd in root.federates.values(): 
"""
<%include file="/header.makot" args="root=root"/>
"""

import pika
import sys
import threading

class Connection_Almas:
    def __init__(self) -> None:
        credentials = pika.PlainCredentials('admin', 'admin_password')
        parameters = pika.ConnectionParameters(host='localhost', port=5672, credentials=credentials)
        self.sub_connection = pika.BlockingConnection(parameters=parameters)
        self.sub_channel = self.sub_connection.channel()
        result = self.sub_channel.queue_declare('', exclusive=True)
        self.sub_queue_name = result.method.queue

        self.pub_connection = pika.BlockingConnection(parameters=parameters)
        self.pub_channel = self.pub_connection.channel()
        #result = self.pub_channel.queue_declare('', exclusive=True)
        #self.pub_queue_name = result.method.queue


    def do_subscribe(self, topic):
        self.sub_channel.exchange_declare(exchange=topic, exchange_type='topic')
        self.sub_channel.queue_bind(
            exchange=topic, queue=self.sub_queue_name, routing_key=topic
        )

    def do_publish(self, topic):
        self.pub_channel.exchange_declare(exchange=topic, exchange_type='topic')
        pass

    def publish(self, topic, Serialized):
        self.pub_channel.basic_publish(exchange=topic, routing_key=topic, body=Serialized)

    def start(self):
        ret = threading.Thread(target=self.recieving, daemon=True)
        ret.start()
        return ret

    def recieving(self):
        self.sub_channel.basic_consume(
            queue=self.sub_queue_name, on_message_callback=self.callback, auto_ack=True
            )
        self.sub_channel.start_consuming()

    def recievie(self, topic, value):
        pass

    def callback(self, ch, method, properties, body):
        self.recievie(method.routing_key, body)
        # print(f" [x] {method.routing_key}:{body}")


ALMAS-FILE-INFO
rabbitmq/python/${fd.name|filters.cap}/Core/protocol.py
ALMAS-FILE-SEPRATE
% endfor

