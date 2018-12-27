/*class IDEDirectory {
  IDEDirectory(this.name, this.files);

  final String name;
  final List<IDEFile> files;
}*/

class IDEEntity {

  IDEEntity({this.name, this.files, this.isFile}) : assert((isFile && files.isEmpty) || !isFile);

  final bool isFile;
  final String name;
  final List<IDEEntity> files;
}