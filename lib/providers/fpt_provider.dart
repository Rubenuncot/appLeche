import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ftpconnect/ftpconnect.dart';

class FtpService extends ChangeNotifier{
  final String host;
  final String user;
  final String pass;
  final int port;
  final String path;

  FtpService(
      {required this.host,
      required this.user,
      required this.pass,
      required this.port,
      required this.path});

  static bool connect = false;

  Future<bool> downloadFileFromFTP(String fileName, String savePath) async {
    FTPConnect ftpConnect = await conect();
    try {
      await ftpConnect.changeDirectory('$path/GestionL');

      final response = await ftpConnect.downloadFile(fileName, File(savePath));
      if (!response) {
        print('Error downloading file');
        return false;
      } else {
        print('File downloaded successfully');
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      await closeConnection(ftpConnect);
    }
  }

  Future<bool> uploadFileFtp(File file) async {
    FTPConnect ftpConnect = await conect();
    try {
      await ftpConnect.changeDirectory('$path/PDA');

      final response = await ftpConnect.uploadFile(file);
      if (!response) {
        print('Error uploading file');
        return false;
      } else {
        print('File uploaded successfully');
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      await closeConnection(ftpConnect);
    }
  }
  
  Future<FTPConnect> conect() async{
    final ftpConnect = FTPConnect(host, user: user, pass: pass, port: port);
    if(!connect){
      await ftpConnect.connect();
      connect = true;
    }
    return ftpConnect;
  }
  
  Future<bool> closeConnection(FTPConnect ftpConnect) async {
    connect = false;
    return await ftpConnect.disconnect();
  }
}
