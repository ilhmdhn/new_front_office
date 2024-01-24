  bool isNullOrEmpty(value){
    return value == null || value.isEmpty;
  }

  bool isNotNullOrEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }