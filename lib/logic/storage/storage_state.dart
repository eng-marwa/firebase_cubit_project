abstract class StorageState {}

class UploadFileInitial extends StorageState {}

class FileUploaded extends StorageState {
  String downloadUrl;

  FileUploaded(this.downloadUrl);
}

class UploadFileLoading extends StorageState {}

class UploadFileFailure extends StorageState {
  String message;

  UploadFileFailure(this.message);
}
