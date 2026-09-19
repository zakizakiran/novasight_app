/// DTO model for Fase API response.
/// Maps to the OpenAPI schema: FaseResponse (GET /api/fases).
class FaseModel {
  final int id;
  final String kode;

  FaseModel({
    required this.id,
    required this.kode,
  });

  factory FaseModel.fromJson(Map<String, dynamic> json) {
    return FaseModel(
      id: json['id'] as int,
      kode: json['kode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
    };
  }

  String get displayName =>
      kode.trim().toLowerCase().startsWith('fase')
          ? kode.trim()
          : 'Fase ${kode.trim()}';

  @override
  String toString() => displayName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          kode == other.kode;

  @override
  int get hashCode => id.hashCode ^ kode.hashCode;

  /// Default Kurikulum Merdeka fases fallback when offline.
  static List<FaseModel> get defaultFases => [
        FaseModel(id: 1, kode: 'A'),
        FaseModel(id: 2, kode: 'B'),
        FaseModel(id: 3, kode: 'C'),
        FaseModel(id: 4, kode: 'D'),
        FaseModel(id: 5, kode: 'E'),
        FaseModel(id: 6, kode: 'F'),
      ];
}
