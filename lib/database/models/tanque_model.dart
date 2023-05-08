class Tanque{
  String codigo;
  double litros;
  bool muestra; /* En el ficheo va como 1 o 0 */
  double temp;

  Tanque({required this.codigo, this.litros = 0, this.muestra = true, this.temp = 0});
}