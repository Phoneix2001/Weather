


import 'status.dart';

class ApiResponse<T>{

  Status status ;
  T? data;
  String? message;

  ApiResponse(this.status,this.data,this.message);

  ApiResponse.loading():status= Status.loading;

  ApiResponse.completed(this.data) : status = Status.completed;
  ApiResponse.error(this.message) : status = Status.error;
  ApiResponse.noInternet(this.message) : status = Status.noInternet;
  @override
  String toString(){
     return "Status : $status \n Message : $message \n Data : $data";
  }
}