enum EnumBusServiceStatus {
  on(label: "on"),
  off(label: "off"),
  ;

  final String label;
  const EnumBusServiceStatus({required this.label});
}
