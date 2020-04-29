import 'package:flutter/material.dart';

class SalonTime {
  final String startTime;
  final String endTime;
  final double price;
  final int discountPercent;
  final String status;
  final bool isAvailable;
  final bool isReservable;
  final bool isReserved;

  SalonTime({
    this.startTime,
    this.endTime,
    this.price,
    this.discountPercent,
    this.status,
    this.isAvailable,
    this.isReservable,
    this.isReserved,
  });
}
