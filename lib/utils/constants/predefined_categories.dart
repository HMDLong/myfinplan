import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/category/category_group.dart';

final categoryGroups = <String, ParentCategory>{
  "e1": ParentCategory(id: "e1", name: "Tiền nhà", icon: Icons.house),
  "e2": ParentCategory(id: "e2", name: "Ăn uống", icon: Icons.currency_pound_sharp),
  "e3": ParentCategory(id: "e3", name: "Di chuyển", icon: Icons.currency_pound_sharp),
  "e4": ParentCategory(id: "e4", name: "Thiết yếu", icon: Icons.currency_pound_sharp),
  "e5": ParentCategory(id: "e5", name: "Giáo dục", icon: Icons.currency_pound_sharp),
  "e6": ParentCategory(id: "e6", name: "Giải trí", icon: Icons.currency_pound_sharp),
  "e7": ParentCategory(id: "e7", name: "Cá nhân", icon: Icons.currency_pound_sharp),
  "e8": ParentCategory(id: "e8", name: "Sức khỏe", icon: Icons.currency_pound_sharp),
  "e9": ParentCategory(id: "e9", name: "Cho đi", icon: Icons.currency_pound_sharp),
  "e10": ParentCategory(id: "e10", name: "Đăng ký", icon: Icons.currency_pound_sharp),
  "i1": ParentCategory(id: "i1", name: "Thu nhập", icon: Icons.currency_pound_sharp),
  "t1": ParentCategory(id: "t1", name: "Chuyển khoản", icon: Icons.currency_pound_sharp),
};

final predefinedCategories = <List<dynamic>>[
  //
  ["e1.1", "Tiền thuê", Icons.currency_pound_sharp],
  ["e1.2", "Bảo hiểm thuê nhà", Icons.currency_pound_sharp],
  ["e1.3", "Sửa chữa", Icons.currency_pound_sharp],
  ["e1.4", "Nâng cấp", Icons.currency_pound_sharp],
  ["e1.5", "Đồ gia dụng", Icons.currency_pound_sharp],
  ["e1.6", "Tiền nhà khác", Icons.currency_pound_sharp],
  //
  ["e2.1", "Đi chợ", Icons.currency_pound_sharp],
  ["e2.2", "Ăn hàng", Icons.currency_pound_sharp],
  ["e2.3", "Café", Icons.currency_pound_sharp],
  ["e2.4", "Ăn uống khác", Icons.currency_pound_sharp],
  //
  ["e3.1", "Phí phương tiện", Icons.currency_pound_sharp],
  ["e3.2", "Fare", Icons.currency_pound_sharp],
  ["e3.3", "Sửa chữa", Icons.currency_pound_sharp],
  ["e3.4", "Đăng kiểm", Icons.currency_pound_sharp],
  ["e3.5", "Nhiên liệu", Icons.currency_pound_sharp],
  ["e3.6", "Phí đỗ xe", Icons.currency_pound_sharp],
  ["e3.7", "Di chuyển khác", Icons.currency_pound_sharp],
  //
  ["e4.1", "Điện", Icons.currency_pound_sharp],
  ["e4.2", "Nước", Icons.currency_pound_sharp],
  ["e4.3", "Vệ sinh", Icons.currency_pound_sharp],
  ["e4.4", "Gas", Icons.currency_pound_sharp],
  ["e4.5", "Truyền hình/Cable", Icons.currency_pound_sharp],
  ["e4.6", "Điện thoại", Icons.currency_pound_sharp],
  ["e4.7", "Internet", Icons.currency_pound_sharp],
  ["e4.8", "Thiết yếu khác", Icons.currency_pound_sharp],
  //
  ["e5.1", "Tiền học chính", Icons.currency_pound_sharp],
  ["e5.2", "Gia sư", Icons.currency_pound_sharp],
  ["e5.3", "Trường luyện thi", Icons.currency_pound_sharp],
  ["e5.4", "Khóa học", Icons.currency_pound_sharp],
  ["e5.5", "Học phí khác", Icons.currency_pound_sharp],
  //
  ["e6.1", "Hoạt động", Icons.currency_pound_sharp],
  ["e6.2", "Sách", Icons.currency_pound_sharp],
  ["e6.3", "Games", Icons.currency_pound_sharp],
  ["e6.4", "Vui chơi", Icons.currency_pound_sharp],
  ["e6.5", "Sở thích", Icons.currency_pound_sharp],
  ["e6.6", "Phim/Nhạc", Icons.currency_pound_sharp],
  ["e6.7", "Dã ngoại", Icons.currency_pound_sharp],
  ["e6.8", "Thể thao", Icons.currency_pound_sharp],
  ["e6.9", "Đồ chơi", Icons.currency_pound_sharp],
  ["e6.10", "Du lịch", Icons.currency_pound_sharp],
  ["e6.11", "Giải trí khác", Icons.currency_pound_sharp],
  //
  ["e7.1", "Quần áo", Icons.currency_pound_sharp],
  ["e7.2", "Vật dụng cá nhân", Icons.currency_pound_sharp],
  ["e7.3", "Làm tóc", Icons.currency_pound_sharp],
  ["e7.4", "Trang sức/Phụ kiện", Icons.currency_pound_sharp],
  ["e7.5", "Thú cưng", Icons.currency_pound_sharp],
  ["e7.6", "Cá nhân khác", Icons.currency_pound_sharp],
  //
  ["e8.1", "Bảo hiểm y tế", Icons.currency_pound_sharp],
  ["e8.2", "Khám bệnh", Icons.currency_pound_sharp],
  ["e8.3", "Thuốc", Icons.currency_pound_sharp],
  ["e8.4", "Thục phẩm chức năng", Icons.currency_pound_sharp],
  ["e8.5", "Khác", Icons.currency_pound_sharp],
  //
  ["e9.1", "Quà", Icons.currency_pound_sharp],
  ["e9.2", "Quyên góp", Icons.currency_pound_sharp],
  ["e9.3", "Khác", Icons.currency_pound_sharp],
  //
  ["e10.1", "Báo", Icons.currency_pound_sharp],
  ["e10.2", "Tạp chí", Icons.currency_pound_sharp],
  ["e10.3", "Khác", Icons.currency_pound_sharp],
  //
  ["i1.1", "Lương", Icons.currency_pound_sharp],
  ["i1.2", "Đầu tư", Icons.currency_pound_sharp],
  ["i1.3", "Cho thuê", Icons.currency_pound_sharp],
  ["i1.4", "Khác", Icons.currency_pound_sharp],
  //
  ["t1.1", "Trả nợ tín dụng", Icons.currency_pound_sharp],
  ["t1.2", "Rút tiền mặt", Icons.currency_pound_sharp],
  ["t1.3", "Tiết kiệm", Icons.currency_pound_sharp],
  ["t1.4", "Khác", Icons.currency_pound_sharp],
];
