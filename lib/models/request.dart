class ServiceRequest {
  String fullName;
  String email;
  String phone;
  String serviceType;
  String description;
  bool isAccepted; 

  ServiceRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.serviceType,
    required this.description,
    this.isAccepted = false,
  });
}
