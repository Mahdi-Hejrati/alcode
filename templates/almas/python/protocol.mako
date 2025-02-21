<%! 
import filters.python as filters
%>
% for fd in root.federates.values(): 
"""
<%include file="/header.makot" args="root=root"/>
"""

import time
import ctypes
import os
from sys import platform


class Protocol:
    def __init__(self, config) -> None:
        self.config = config
        self.core = ctypes.CDLL(f"./almas_{config['service']}.so")
        self.core.init.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_char_p, ctypes.c_char_p]
        self.core.init.restype = ctypes.c_int
        self.core.publish.argtypes = [ctypes.c_char_p, ctypes.c_char_p]
        self.core.publish.restype = ctypes.c_int
        self.core.register_subscribe.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int]
        self.core.register_subscribe.restype = ctypes.c_int
        if platform == "win32":
            self.CALLBACKFUNC = ctypes.WINFUNCTYPE(ctypes.c_void_p, ctypes.c_void_p)
        else:
            self.CALLBACKFUNC = ctypes.CFUNCTYPE(ctypes.c_void_p, ctypes.c_void_p)
        self.core.start.argtypes = [ctypes.c_char_p, self.CALLBACKFUNC]
        self.core.start.restype = ctypes.c_int
        self.core.init("127.0.0.1".encode('utf-8'), 8000, "admin".encode('utf-8'), "123".encode('utf-8'))
    


    def do_subscribe(self, topic):
        self.sub_channel.exchange_declare(exchange=topic, exchange_type='topic')
        self.sub_channel.queue_bind(
            exchange=topic, queue=self.sub_queue_name, routing_key=topic
        )

    def do_publish(self, topic):
        self.core.publish(topic.encode('utf-8'), param.ToString().encode('utf-8'))
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

