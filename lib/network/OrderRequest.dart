class OrderRequest {
  final int serviceId;
  final double lat;
  final double log;
  final String description;
  final String address;
  final String city;
  final String completionDate;
  final String completionTime;
  final List<Answer> answers;

  OrderRequest({
    required this.serviceId,
    required this.lat,
    required this.log,
    required this.description,
    required this.address,
    required this.city,
    required this.completionDate,
    required this.completionTime,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'lat': lat,
      'log': log,
      'description': description,
      'address': address,
      'city': city,
      'completion_date': completionDate,
      'completion_time': completionTime,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class Answer {
  final int questionId;
  final String answer;

  Answer({required this.questionId, required this.answer});

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
    };
  }
}
