import 'dart:convert';
import 'dart:io';
import 'package:front_office_2/tools/toast.dart';
import 'package:udp/udp.dart';

class UdpSender {
  final String address;
  final int port;

  UdpSender({required this.address, required this.port});

  Future<void> sendUdpMessage(String message) async {
    try {
      final sender = await UDP.bind(Endpoint.any(port: const Port(0)));
      final data = utf8.encode(message);

      var target = Endpoint.unicast(InternetAddress(address), port: Port(port));
      await sender.send(data, target);

      sender.close();
    } catch (e) {
      showToastError('Gagal mengirim sinyal $e');
    }
  }
}
