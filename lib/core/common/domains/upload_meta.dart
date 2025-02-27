// ignore_for_file: public_member_api_docs, sort_constructors_first


import '../../../features/auth/domain/entities/user_auth.dart';
import '../enums/common_enums.dart';

class UploadMeta {
  final DateTime createdAt;
  final String createdBy;
  final DateTime? lastUpdatedAt;
  final String lastUpdatedBy;
  final int updateCount;


  UploadMeta({
    required this.createdAt,
    required this.createdBy,
    this.lastUpdatedAt,
    required this.lastUpdatedBy,
    required this.updateCount,
  });


  factory UploadMeta.newInstance({required UserAuth auth}) {
    return UploadMeta(
      createdAt: DateTime.now(),
      createdBy: auth.id,
      lastUpdatedAt: null,
      lastUpdatedBy: auth.id,
      updateCount: 0,
    );
  }



  UploadMeta copyWith({
    DateTime? createdAt,
    String? createdBy,
    DateTime? lastUpdatedAt,
    String? lastUpdatedBy,
    int? updateCount,
    OnlineStatus? onlineStatus,
  }) {
    return UploadMeta(
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      updateCount: updateCount ?? this.updateCount,
    );
  }

  @override
  String toString() {
    return 'UploadMeta(createdAt: $createdAt, createdBy: $createdBy, lastUpdatedAt: $lastUpdatedAt, lastUpdatedBy: $lastUpdatedBy, updateCount: $updateCount)';
  }

  @override
  bool operator ==(covariant UploadMeta other) {
    if (identical(this, other)) return true;
  
    return 
      other.createdAt == createdAt &&
      other.createdBy == createdBy &&
      other.lastUpdatedAt == lastUpdatedAt &&
      other.lastUpdatedBy == lastUpdatedBy &&
      other.updateCount == updateCount;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
      createdBy.hashCode ^
      lastUpdatedAt.hashCode ^
      lastUpdatedBy.hashCode ^
      updateCount.hashCode;
  }
}
