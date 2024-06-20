import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Screen Two ASAP'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              //Get.toNamed('/');
            },
            child: Column(
              children: [
                const Center(child: Text('Go back')),
                Text('Testing'),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webdextro/constants.dart';
import 'package:intl/intl.dart';

import 'services_controller.dart';

class ServiesList extends StatefulWidget {
  const ServiesList({super.key});

  @override
  State<ServiesList> createState() => _ServiesListState();
}

class _ServiesListState extends State<ServiesList> {
  final ServicesController guestController = Get.put(ServicesController());

  @override
  void initState() {
    //guestController.LoadData();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    // Parse the check-out date
    DateTime checkOutDate = format.parse(checkOut);
    // Get the current date and time
    DateTime now = DateTime.now();

    // Check if the checkout date is earlier than the current date and time
    return checkOutDate
        .isBefore(now); // Returns true if checkout is in the past
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      // Handle successful deletion here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      // Handle errors here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.allListData.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Guest List',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.018)),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        child: DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.05,
                          columns: const [
                            DataColumn(label: Text('Sr.No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Check In')),
                            DataColumn(label: Text('Check Out')),
                            DataColumn(label: Text('Room\nNo')),
                            DataColumn(label: Text('Edit')),
                            DataColumn(label: Text('Delete')),
                            DataColumn(label: Text('Login\nQR code')),
                          ],
                          rows: guestController.allListData
                              .asMap()
                              .map((index, guest) {
                                print(guestController.isActive.value);
                                guestController.isActive[index] =
                                    isCheckoutDatePast(guest['check_out']);
                                return MapEntry(
                                    index,
                                    DataRow(cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(Text(
                                        guest['username'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                      DataCell(Text(
                                        guest['check_in'],
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataCell(Text(
                                        guest['check_out'],
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataCell(Text(guest['room_no'])),
                                      DataCell(IconButton(
                                          onPressed: () {
                                            if (!guestController
                                                .isActive[index]) {}

                                            // Implement your edit action
                                          },
                                          icon: Icon(Icons.edit,
                                              color: Colors.white))),
                                      DataCell(IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Confirm Delete'),
                                                  content: Text(
                                                      'Are you sure you want to delete this guest?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        // Dismiss the dialog but don't delete anything
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        // Perform the deletion operation here
                                                        // For now, we'll just close the dialog
                                                        Navigator.of(context)
                                                            .pop();
                                                        deleteGuestUser(context,
                                                            guest['doc_id']);
                                                      },
                                                      child: Text('Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            // Implement your delete action
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.red))),
                                      DataCell(
                                        IconButton(
                                            onPressed: () {
                                              if (!guestController
                                                  .isActive[index]) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    content: Container(
                                                      height: 200,
                                                      width: 200,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: QrImageView(
                                                          data:
                                                              'https://autosys-user-dashboard-login.web.app/?refId=${guest['doc_id']}',
                                                          version:
                                                              QrVersions.auto,
                                                          size: 200,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              // Implement your delete action
                                            },
                                            icon: Icon(Icons.qr_code,
                                                color: Colors.white)),
                                      ),
                                    ]));
                              })
                              .values
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webdextro/constants.dart';
import 'package:intl/intl.dart';
import 'services_controller.dart';

class ServiesList extends StatefulWidget {
  const ServiesList({super.key});
  @override
  State<ServiesList> createState() => _ServiesListState();
}

class _ServiesListState extends State<ServiesList> {
  final ServicesController guestController = Get.put(ServicesController());
  @override
  void initState() {
    guestController.getFoodOrders();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    // Parse the check-out date
    DateTime checkOutDate = format.parse(checkOut);
    // Get the current date and time
    DateTime now = DateTime.now();
    // Check if the checkout date is earlier than the current date and time
    return checkOutDate
        .isBefore(now); // Returns true if checkout is in the past
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      // Handle successful deletion here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      // Handle errors here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.serviceOrderList.isEmpty
            ? Center(
                child: Text('No Data Found !!'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Services List',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.018)),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        child: DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.05,
                          columns: const [
                            DataColumn(label: Text('Sr.No')),
                            //DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Guest Name')),
                            //DataColumn(label: Text('Food Name')),
                            DataColumn(label: Text('Date Time')),
                            DataColumn(label: Text('Room\nNo')),
                            //DataColumn(label: Text('order Time')),
                            DataColumn(label: Text('Service Status')),
                          ],
                          rows: guestController.serviceOrderList
                              .asMap()
                              .map((index, guest) {
                                return MapEntry(
                                    index,
                                    DataRow(cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(Text(
                                        guest['guest_name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                      // DataCell(Text(
                                      //   guest['food_name'],
                                      //   style: TextStyle(color: Colors.white),
                                      // )),
                                      DataCell(Text(guest['room_name'])),
                                      DataCell(Text(
                                        guest['date_time'],
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataCell(Text(
                                        guest['service_status'],
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ]));
                              })
                              .values
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'services_controller.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});
  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final ServicesController guestController = Get.put(ServicesController());

  @override
  void initState() {
    guestController.getFoodOrders();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    DateTime checkOutDate = format.parse(checkOut);
    DateTime now = DateTime.now();
    return checkOutDate.isBefore(now);
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.serviceOrderList.isEmpty
            ? Center(child: Text('No Data Found !!'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.s,
                      children: [
                        Text('Services List',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.018)),
                        Spacer(),
                        DropdownButton<String>(
                          value: guestController.selectedService.value,
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.white),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.white),
                          underline: Container(
                            height: 2,
                            //color: Colors.white,
                          ),
                          dropdownColor: Colors.grey[800],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                guestController.selectedService.value =
                                    newValue;
                              });
                              switch (newValue) {
                                case 'Food Orders':
                                  guestController.getFoodOrders();
                                  break;
                                case 'Room Service':
                                  guestController.getRoomServiceOrder();
                                  break;
                                case 'Laundry Service':
                                  guestController.getLaundryService();
                                  break;
                              }
                            }
                          },
                          items: <String>[
                            'Food Orders',
                            'Room Service',
                            'Laundry Service'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          width: 550,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        child: DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.05,
                          columns: const [
                            DataColumn(label: Text('Sr.No')),
                            DataColumn(label: Text('Guest Name')),
                            DataColumn(label: Text('Date Time')),
                            DataColumn(label: Text('Room No')),
                            DataColumn(label: Text('Service Status')),
                          ],
                          rows: guestController.serviceOrderList
                              .asMap()
                              .map((index, guest) {
                                return MapEntry(
                                    index,
                                    DataRow(cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(Text(
                                        guest['guest_name'],
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataCell(Text(guest['date_time'],
                                          style:
                                              TextStyle(color: Colors.white))),
                                      DataCell(Text(guest['room_no'])),
                                      DataCell(Text(guest['service_status'],
                                          style:
                                              TextStyle(color: Colors.white))),
                                    ]));
                              })
                              .values
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'services_controller.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});
  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final ServicesController guestController = Get.put(ServicesController());

  @override
  void initState() {
    guestController.getFoodOrders();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    DateTime checkOutDate = format.parse(checkOut);
    DateTime now = DateTime.now();
    return checkOutDate.isBefore(now);
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.serviceOrderList.isEmpty
            ? Center(child: Text('No Data Found !!'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text('Services List',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.018)),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: guestController.selectedService.value,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.white),
                            underline: Container(),
                            dropdownColor: Colors.grey[800],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  guestController.selectedService.value =
                                      newValue;
                                });
                                switch (newValue) {
                                  case 'Food Orders':
                                    guestController.getFoodOrders();
                                    break;
                                  case 'Room Service':
                                    guestController.getRoomServiceOrder();
                                    break;
                                  case 'Laundry Service':
                                    guestController.getLaundryService();
                                    break;
                                }
                              }
                            },
                            items: <String>[
                              'Food Orders',
                              'Room Service',
                              'Laundry Service'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        //SizedBox(width: 550),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        child: DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.05,
                          columns: const [
                            DataColumn(label: Text('Sr.No')),
                            DataColumn(label: Text('Guest Name')),
                            DataColumn(label: Text('Date Time')),
                            DataColumn(label: Text('Room No')),
                            DataColumn(label: Text('Service Status')),
                          ],
                          rows: guestController.serviceOrderList
                              .asMap()
                              .map((index, guest) {
                                return MapEntry(
                                    index,
                                    DataRow(cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(Text(
                                        guest['guest_name'],
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataCell(Text(guest['date_time'],
                                          style:
                                              TextStyle(color: Colors.white))),
                                      DataCell(Text(guest['room_no'])),
                                      DataCell(Text(guest['service_status'],
                                          style:
                                              TextStyle(color: Colors.white))),
                                    ]));
                              })
                              .values
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'services_controller.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});
  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final ServicesController guestController = Get.put(ServicesController());

  @override
  void initState() {
    guestController.getFoodOrders();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    DateTime checkOutDate = format.parse(checkOut);
    DateTime now = DateTime.now();
    return checkOutDate.isBefore(now);
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  List<DataColumn> getDataColumns(String serviceType) {
    switch (serviceType) {
      case 'Food Orders':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Food Name')),
        ];
      case 'Room Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      case 'Laundry Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Laundry Items')),
        ];
      default:
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
        ];
    }
  }

  List<DataCell> getDataCells(String serviceType, Map<String, dynamic> guest) {
    switch (serviceType) {
      case 'Food Orders':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['food_name'], style: TextStyle(color: Colors.white))),
        ];
      case 'Room Service':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['details'], style: TextStyle(color: Colors.white))),
        ];
      case 'Laundry Service':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(Text(
              guest['laundry_items'].map((item) => item['name']).join(', '),
              style: TextStyle(color: Colors.white))),
        ];
      default:
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.serviceOrderList.isEmpty
            ? Center(child: Text('No Data Found !!'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text('Services List',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.018)),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: guestController.selectedService.value,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.white),
                            underline: Container(),
                            dropdownColor: Colors.grey[800],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  guestController.selectedService.value =
                                      newValue;
                                });
                                switch (newValue) {
                                  case 'Food Orders':
                                    guestController.getFoodOrders();
                                    break;
                                  case 'Room Service':
                                    guestController.getRoomServiceOrder();
                                    break;
                                  case 'Laundry Service':
                                    guestController.getLaundryService();
                                    break;
                                }
                              }
                            },
                            items: <String>[
                              'Food Orders',
                              'Room Service',
                              'Laundry Service'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        child: DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.05,
                          columns: getDataColumns(
                              guestController.selectedService.value),
                          rows: guestController.serviceOrderList
                              .asMap()
                              .map((index, guest) {
                                guest['sr_no'] = (index + 1).toString();
                                return MapEntry(
                                    index,
                                    DataRow(
                                        cells: getDataCells(
                                            guestController
                                                .selectedService.value,
                                            guest)));
                              })
                              .values
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'services_controller.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});
  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final ServicesController guestController = Get.put(ServicesController());

  @override
  void initState() {
    guestController.getFoodOrders();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    DateTime checkOutDate = format.parse(checkOut);
    DateTime now = DateTime.now();
    return checkOutDate.isBefore(now);
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  List<DataColumn> getDataColumns(String serviceType) {
    switch (serviceType) {
      case 'Food Orders':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Food Name')),
        ];
      case 'Room Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      case 'Laundry Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      default:
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
        ];
    }
  }

  List<DataCell> getDataCells(String serviceType, Map<String, dynamic> guest) {
    switch (serviceType) {
      case 'Food Orders':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['food_name'], style: TextStyle(color: Colors.white))),
        ];
      case 'Room Service':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['details'], style: TextStyle(color: Colors.white))),
        ];
      case 'Laundry Service':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(Text(
              guest['List_of_laundry']
                  .map((item) => '${item['name']} x${item['quantity']}')
                  .join(', '),
              style: TextStyle(color: Colors.white))),
        ];
      default:
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.serviceOrderList.isEmpty
            ? Center(child: Text('No Data Found !!'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text('Services List',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.018)),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: guestController.selectedService.value,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.white),
                            underline: Container(),
                            dropdownColor: Colors.grey[800],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  guestController.selectedService.value =
                                      newValue;
                                });
                                switch (newValue) {
                                  case 'Food Orders':
                                    guestController.getFoodOrders();
                                    break;
                                  case 'Room Service':
                                    guestController.getRoomServiceOrder();
                                    break;
                                  case 'Laundry Service':
                                    guestController.getLaundryService();
                                    break;
                                }
                              }
                            },
                            items: <String>[
                              'Food Orders',
                              'Room Service',
                              'Laundry Service'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        child: DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.05,
                          columns: getDataColumns(
                              guestController.selectedService.value),
                          rows: guestController.serviceOrderList
                              .asMap()
                              .map((index, guest) {
                                guest['sr_no'] = (index + 1).toString();
                                return MapEntry(
                                    index,
                                    DataRow(
                                        cells: getDataCells(
                                            guestController
                                                .selectedService.value,
                                            guest)));
                              })
                              .values
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'services_controller.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});
  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final ServicesController guestController = Get.put(ServicesController());

  @override
  void initState() {
    guestController.getFoodOrders();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    DateTime checkOutDate = format.parse(checkOut);
    DateTime now = DateTime.now();
    return checkOutDate.isBefore(now);
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  List<DataColumn> getDataColumns(String serviceType) {
    switch (serviceType) {
      case 'Food Orders':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Food Name')),
        ];
      case 'Room Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      case 'Laundry Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      default:
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
        ];
    }
  }

  List<DataCell> getDataCells(String serviceType, Map<String, dynamic> guest) {
    switch (serviceType) {
      case 'Food Orders':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['food_name'], style: TextStyle(color: Colors.white))),
        ];
      case 'Room Service':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['details'], style: TextStyle(color: Colors.white))),
        ];
      case 'Laundry Service':
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
          DataCell(Text(
              guest['List_of_laundry']
                  .map((item) => '${item['name']} x${item['quantity']}')
                  .join(', '),
              style: TextStyle(color: Colors.white))),
        ];
      default:
        return [
          DataCell(Text(guest['sr_no'])),
          DataCell(
              Text(guest['guest_name'], style: TextStyle(color: Colors.white))),
          DataCell(
              Text(guest['date_time'], style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'])),
          DataCell(Text(guest['service_status'],
              style: TextStyle(color: Colors.white))),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.serviceOrderList.isEmpty
            ? Center(child: Text('No Data Found !!'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text('Services List',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.018)),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: guestController.selectedService.value,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.white),
                            underline: Container(),
                            dropdownColor: Colors.grey[800],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  guestController.selectedService.value =
                                      newValue;
                                });
                                switch (newValue) {
                                  case 'Food Orders':
                                    guestController.getFoodOrders();
                                    break;
                                  case 'Room Service':
                                    guestController.getRoomServiceOrder();
                                    break;
                                  case 'Laundry Service':
                                    guestController.getLaundryService();
                                    break;
                                }
                              }
                            },
                            items: <String>[
                              'Food Orders',
                              'Room Service',
                              'Laundry Service'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columnSpacing:
                                MediaQuery.of(context).size.width * 0.05,
                            columns: getDataColumns(
                                guestController.selectedService.value),
                            rows: guestController.serviceOrderList
                                .asMap()
                                .map((index, guest) {
                                  guest['sr_no'] = (index + 1).toString();
                                  return MapEntry(
                                      index,
                                      DataRow(
                                          cells: getDataCells(
                                              guestController
                                                  .selectedService.value,
                                              guest)));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'services_controller.dart';

// class ServicesList extends StatefulWidget {
//   const ServicesList({super.key});
//   @override
//   State<ServicesList> createState() => _ServicesListState();
// }

// class _ServicesListState extends State<ServicesList> {
//   final ServicesController guestController = Get.put(ServicesController());

//   @override
//   void initState() {
//     guestController.getFoodOrders();
//     super.initState();
//   }

//   bool isCheckoutDatePast(String checkOut) {
//     DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
//     DateTime checkOutDate = format.parse(checkOut);
//     DateTime now = DateTime.now();
//     return checkOutDate.isBefore(now);
//   }

//   void deleteGuestUser(BuildContext context, String docId) {
//     FirebaseFirestore.instance
//         .collection('guest_user')
//         .doc(docId)
//         .delete()
//         .then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Document successfully deleted!',
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.green,
//       ));
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to delete document: $error',
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.red,
//       ));
//     });
//   }

//   List<DataColumn> getDataColumns(String serviceType) {
//     switch (serviceType) {
//       case 'Food Orders':
//         return const [
//           DataColumn(label: Text('Sr.No')),
//           DataColumn(label: Text('Guest Name')),
//           DataColumn(label: Text('Date Time')),
//           DataColumn(label: Text('Room No')),
//           DataColumn(label: Text('Service Status')),
//           DataColumn(label: Text('Food Name')),
//         ];
//       case 'Room Service':
//         return const [
//           DataColumn(label: Text('Sr.No')),
//           DataColumn(label: Text('Guest Name')),
//           DataColumn(label: Text('Date Time')),
//           DataColumn(label: Text('Room No')),
//           DataColumn(label: Text('Service Status')),
//           DataColumn(label: Text('Details')),
//         ];
//       case 'Laundry Service':
//         return const [
//           DataColumn(label: Text('Sr.No')),
//           DataColumn(label: Text('Guest Name')),
//           DataColumn(label: Text('Date Time')),
//           DataColumn(label: Text('Room No')),
//           DataColumn(label: Text('Service Status')),
//           DataColumn(label: Text('Details')),
//         ];
//       default:
//         return const [
//           DataColumn(label: Text('Sr.No')),
//           DataColumn(label: Text('Guest Name')),
//           DataColumn(label: Text('Date Time')),
//           DataColumn(label: Text('Room No')),
//           DataColumn(label: Text('Service Status')),
//         ];
//     }
//   }

//   List<DataCell> getDataCells(String serviceType, Map<String, dynamic> guest) {
//     switch (serviceType) {
//       case 'Food Orders':
//         return [
//           DataCell(Text(guest['sr_no'] ?? 'N/A')),
//           DataCell(Text(guest['guest_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['date_time'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['room_no'] ?? 'N/A')),
//           DataCell(Text(guest['service_status'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['food_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//         ];
//       case 'Room Service':
//         return [
//           DataCell(Text(guest['sr_no'] ?? 'N/A')),
//           DataCell(Text(guest['guest_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['date_time'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['room_no'] ?? 'N/A')),
//           DataCell(Text(guest['service_status'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['details'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//         ];
//       case 'Laundry Service':
//         return [
//           DataCell(Text(guest['sr_no'] ?? 'N/A')),
//           DataCell(Text(guest['guest_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['date_time'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['room_no'] ?? 'N/A')),
//           DataCell(Text(guest['service_status'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(
//               (guest['List_of_laundry'] != null
//                   ? guest['List_of_laundry']
//                       .map((item) => '${item['name']} x${item['quantity']}')
//                       .join(', ')
//                   : 'N/A'),
//               style: TextStyle(color: Colors.white))),
//         ];
//       default:
//         return [
//           DataCell(Text(guest['sr_no'] ?? 'N/A')),
//           DataCell(Text(guest['guest_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['date_time'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['room_no'] ?? 'N/A')),
//           DataCell(Text(guest['service_status'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//         ];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         body: guestController.serviceOrderList.isEmpty
//             ? Center(child: Text('No Data Found !!'))
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Row(
//                       children: [
//                         Text('Services List',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize:
//                                     MediaQuery.of(context).size.width * 0.018)),
//                         Spacer(),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[800],
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 12),
//                           child: DropdownButton<String>(
//                             value: guestController.selectedService.value,
//                             icon: Icon(Icons.arrow_drop_down,
//                                 color: Colors.white),
//                             iconSize: 24,
//                             elevation: 16,
//                             style: TextStyle(color: Colors.white),
//                             underline: Container(),
//                             dropdownColor: Colors.grey[800],
//                             onChanged: (String? newValue) {
//                               if (newValue != null) {
//                                 setState(() {
//                                   guestController.selectedService.value =
//                                       newValue;
//                                 });
//                                 switch (newValue) {
//                                   case 'Food Orders':
//                                     guestController.getFoodOrders();
//                                     break;
//                                   case 'Room Service':
//                                     guestController.getRoomServiceOrder();
//                                     break;
//                                   case 'Laundry Service':
//                                     guestController.getLaundryService();
//                                     break;
//                                 }
//                               }
//                             },
//                             items: <String>[
//                               'Food Orders',
//                               'Room Service',
//                               'Laundry Service'
//                             ].map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                         SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.35),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Obx(() {
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: SingleChildScrollView(
//                           child: DataTable(
//                             columnSpacing:
//                                 MediaQuery.of(context).size.width * 0.05,
//                             columns: getDataColumns(
//                                 guestController.selectedService.value),
//                             rows: guestController.serviceOrderList
//                                 .asMap()
//                                 .map((index, guest) {
//                                   guest['sr_no'] = (index + 1).toString();
//                                   return MapEntry(
//                                       index,
//                                       DataRow(
//                                           cells: getDataCells(
//                                               guestController
//                                                   .selectedService.value,
//                                               guest)));
//                                 })
//                                 .values
//                                 .toList(),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'services_controller.dart';

// class ServicesList extends StatefulWidget {
//   const ServicesList({super.key});
//   @override
//   State<ServicesList> createState() => _ServicesListState();
// }

// class _ServicesListState extends State<ServicesList> {
//   final ServicesController guestController = Get.put(ServicesController());

//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     guestController.getFoodOrders();
//     super.initState();
//   }

//   bool isCheckoutDatePast(String checkOut) {
//     DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
//     DateTime checkOutDate = format.parse(checkOut);
//     DateTime now = DateTime.now();
//     return checkOutDate.isBefore(now);
//   }

//   Future<void> updateServiceStatus(int index, String newStatus) async {
//     try {
//       // Get the document
//       DocumentSnapshot documentSnapshot =
//           await firestore.collection('hotel_services').doc('services').get();
//       if (documentSnapshot.exists) {
//         List<dynamic> serviceOrderList = documentSnapshot.get('food_orders');
//         if (index >= 0 && index < serviceOrderList.length) {
//           serviceOrderList[index]['service_status'] = newStatus;
//           // Update the document
//           await firestore.collection('hotel_services').doc('services').update({
//             'food_orders': serviceOrderList,
//           });
//           print('Document updated successfully');
//         } else {
//           print('Index out of range');
//         }
//       } else {
//         print('Document does not exist');
//       }
//     } catch (e) {
//       print('Error updating document: $e');
//     }
//   }

//   void deleteGuestUser(BuildContext context, String docId) {
//     FirebaseFirestore.instance
//         .collection('guest_user')
//         .doc(docId)
//         .delete()
//         .then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Document successfully deleted!',
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.green,
//       ));
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to delete document: $error',
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.red,
//       ));
//     });
//   }

//   List<DataColumn> getDataColumns(String serviceType) {
//     switch (serviceType) {
//       case 'Food Orders':
//         return const [
//           DataColumn(label: Text('Sr.No')),
//           DataColumn(label: Text('Guest Name')),
//           DataColumn(label: Text('Date Time')),
//           DataColumn(label: Text('Room No')),
//           DataColumn(label: Text('Service Status')),
//           DataColumn(label: Text('Food Name')),
//         ];
//       case 'Room Service':
//         return const [
//           DataColumn(label: Text('Sr.No')),
//           DataColumn(label: Text('Guest Name')),
//           DataColumn(label: Text('Date Time')),
//           DataColumn(label: Text('Room No')),
//           DataColumn(label: Text('Service Status')),
//           DataColumn(label: Text('Details')),
//         ];
//       case 'Laundry Service':
//         return const [
//           DataColumn(label: Text('Sr.No')),
//           DataColumn(label: Text('Guest Name')),
//           DataColumn(label: Text('Date Time')),
//           DataColumn(label: Text('Room No')),
//           DataColumn(label: Text('Service Status')),
//           DataColumn(label: Text('Details')),
//         ];
//       default:
//         return const [
//           DataColumn(label: Text('Sr.No')),
//           DataColumn(label: Text('Guest Name')),
//           DataColumn(label: Text('Date Time')),
//           DataColumn(label: Text('Room No')),
//           DataColumn(label: Text('Service Status')),
//         ];
//     }
//   }

//   List<DataCell> getDataCells(String serviceType, Map<String, dynamic> guest) {
//     switch (serviceType) {
//       case 'Food Orders':
//         return [
//           DataCell(Text(guest['sr_no'] ?? 'N/A')),
//           DataCell(Text(guest['guest_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['date_time'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['room_no'] ?? 'N/A')),
//           DataCell(Text(guest['service_status'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(
//             DropdownButton<String>(
//               value: guest['service_status'],
//               items: <String>['pending', 'In Progress', 'Done']
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(
//                     value,
//                     style: TextStyle(
//                         color: value.toString().contains('pending')
//                             ? Colors.red
//                             : value.toString().contains('In Progress')
//                                 ? Colors.amber
//                                 : Colors.green),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) async {
//                 if (newValue != null) {
//                   setState(() {
//                     guest['service_status'] = newValue;
//                   });
//                   updateServiceStatus(index, newValue);
//                 }
//               },
//             ),
//           ),
//           DataCell(Text(guest['food_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//         ];
//       case 'Room Service':
//         return [
//           DataCell(Text(guest['sr_no'] ?? 'N/A')),
//           DataCell(Text(guest['guest_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['date_time'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['room_no'] ?? 'N/A')),
//           DataCell(Text(guest['service_status'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['details'] ?? '',
//               style: TextStyle(color: Colors.white))),
//         ];
//       case 'Laundry Service':
//         return [
//           DataCell(Text(guest['sr_no'] ?? 'N/A')),
//           DataCell(Text(guest['guest_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['date_time'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['room_no'] ?? 'N/A')),
//           DataCell(Text(guest['service_status'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(
//               (guest['List_of_laundry'] != null
//                   ? guest['List_of_laundry']
//                       .map((item) => '${item['name']} x${item['quantity']}')
//                       .join(', ')
//                   : ''),
//               style: TextStyle(color: Colors.white))),
//         ];
//       default:
//         return [
//           DataCell(Text(guest['sr_no'] ?? 'N/A')),
//           DataCell(Text(guest['guest_name'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['date_time'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//           DataCell(Text(guest['room_no'] ?? 'N/A')),
//           DataCell(Text(guest['service_status'] ?? 'N/A',
//               style: TextStyle(color: Colors.white))),
//         ];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         body: guestController.serviceOrderList.isEmpty
//             ? Center(child: Text('No Data Found !!'))
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Row(
//                       children: [
//                         Text('Services List',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize:
//                                     MediaQuery.of(context).size.width * 0.018)),
//                         Spacer(),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[800],
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 12),
//                           child: DropdownButton<String>(
//                             value: guestController.selectedService.value,
//                             icon: Icon(Icons.arrow_drop_down,
//                                 color: Colors.white),
//                             iconSize: 24,
//                             elevation: 16,
//                             style: TextStyle(color: Colors.white),
//                             underline: Container(),
//                             dropdownColor: Colors.grey[800],
//                             onChanged: (String? newValue) {
//                               if (newValue != null) {
//                                 setState(() {
//                                   guestController.selectedService.value =
//                                       newValue;
//                                 });
//                                 switch (newValue) {
//                                   case 'Food Orders':
//                                     guestController.getFoodOrders();
//                                     break;
//                                   case 'Room Service':
//                                     guestController.getRoomServiceOrder();
//                                     break;
//                                   case 'Laundry Service':
//                                     guestController.getLaundryService();
//                                     break;
//                                 }
//                               }
//                             },
//                             items: <String>[
//                               'Food Orders',
//                               'Room Service',
//                               'Laundry Service'
//                             ].map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                         SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.35),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Obx(() {
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: SingleChildScrollView(
//                           child: DataTable(
//                             columnSpacing:
//                                 MediaQuery.of(context).size.width * 0.05,
//                             columns: getDataColumns(
//                                 guestController.selectedService.value),
//                             rows: guestController.serviceOrderList
//                                 .asMap()
//                                 .map((index, guest) {
//                                   guest['sr_no'] = (index + 1).toString();
//                                   return MapEntry(
//                                       index,
//                                       DataRow(
//                                           cells: getDataCells(
//                                               guestController
//                                                   .selectedService.value,
//                                               guest)));
//                                 })
//                                 .values
//                                 .toList(),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'services_controller.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});
  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final ServicesController guestController = Get.put(ServicesController());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    guestController.getFoodOrders();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    DateTime checkOutDate = format.parse(checkOut);
    DateTime now = DateTime.now();
    return checkOutDate.isBefore(now);
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  List<DataColumn> getDataColumns(String serviceType) {
    switch (serviceType) {
      case 'Food Orders':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Food Name')),
        ];
      case 'Room Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      case 'Laundry Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      default:
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
        ];
    }
  }

  List<DataCell> getDataCells(
      String serviceType, Map<String, dynamic> guest, int index) {
    switch (serviceType) {
      case 'Food Orders':
        return [
          DataCell(Text(guest['sr_no'] ?? 'N/A')),
          DataCell(Text(guest['guest_name'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['date_time'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'] ?? 'N/A')),
          DataCell(
            DropdownButton<String>(
              value: guest['service_status'],
              items: <String>['pending', 'In Progress', 'Done']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: value.toString().contains('pending')
                            ? Colors.red
                            : value.toString().contains('In Progress')
                                ? Colors.amber
                                : Colors.green),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  setState(() {
                    guest['service_status'] = newValue;
                  });
                  await updateServiceStatus(index, newValue);
                }
              },
            ),
          ),
          DataCell(Text(guest['food_name'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
        ];
      case 'Room Service':
        return [
          DataCell(Text(guest['sr_no'] ?? 'N/A')),
          DataCell(Text(guest['guest_name'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['date_time'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'] ?? 'N/A')),
          DataCell(
            DropdownButton<String>(
              value: guest['service_status'],
              items: <String>['pending', 'In Progress', 'Done']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: value.toString().contains('pending')
                            ? Colors.red
                            : value.toString().contains('In Progress')
                                ? Colors.amber
                                : Colors.green),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  setState(() {
                    guest['service_status'] = newValue;
                  });
                  await updateServiceStatus(index, newValue);
                }
              },
            ),
          ),
          DataCell(Text(guest['details'] ?? '',
              style: TextStyle(color: Colors.white))),
        ];
      case 'Laundry Service':
        return [
          DataCell(Text(guest['sr_no'] ?? 'N/A')),
          DataCell(Text(guest['guest_name'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['date_time'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'] ?? 'N/A')),
          DataCell(
            DropdownButton<String>(
              value: guest['service_status'],
              items: <String>['pending', 'In Progress', 'Done']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: value.toString().contains('pending')
                            ? Colors.red
                            : value.toString().contains('In Progress')
                                ? Colors.amber
                                : Colors.green),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  setState(() {
                    guest['service_status'] = newValue;
                  });
                  await updateServiceStatus(index, newValue);
                }
              },
            ),
          ),
          DataCell(Text(
              (guest['List_of_laundry'] != null
                  ? guest['List_of_laundry']
                      .map((item) => '${item['name']} x${item['quantity']}')
                      .join(', ')
                  : ''),
              style: TextStyle(color: Colors.white))),
        ];
      default:
        return [
          DataCell(Text(guest['sr_no'] ?? 'N/A')),
          DataCell(Text(guest['guest_name'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['date_time'] ?? 'N/A',
              style: TextStyle(color: Colors.white))),
          DataCell(Text(guest['room_no'] ?? 'N/A')),
          DataCell(
            DropdownButton<String>(
              value: guest['service_status'],
              items: <String>['pending', 'In Progress', 'Done']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: value.toString().contains('pending')
                            ? Colors.red
                            : value.toString().contains('In Progress')
                                ? Colors.amber
                                : Colors.green),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  setState(() {
                    guest['service_status'] = newValue;
                  });
                  await updateServiceStatus(index, newValue);
                }
              },
            ),
          ),
        ];
    }
  }

  Future<void> updateServiceStatus(int index, String newStatus) async {
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('hotel_services').doc('services').get();
      if (documentSnapshot.exists) {
        List<dynamic> serviceOrderList = documentSnapshot.get('food_orders');
        if (index >= 0 && index < serviceOrderList.length) {
          serviceOrderList[index]['service_status'] = newStatus;
          await firestore.collection('hotel_services').doc('services').update({
            'food_orders': serviceOrderList,
          });
          print('Document updated successfully');
        } else {
          print('Index out of range');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.serviceOrderList.isEmpty
            ? Center(child: Text('No Data Found !!'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text('Services List',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.018)),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: guestController.selectedService.value,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.white),
                            underline: Container(),
                            dropdownColor: Colors.grey[800],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  guestController.selectedService.value =
                                      newValue;
                                });
                                switch (newValue) {
                                  case 'Food Orders':
                                    guestController.getFoodOrders();
                                    break;
                                  case 'Room Service':
                                    guestController.getRoomServiceOrder();
                                    break;
                                  case 'Laundry Service':
                                    guestController.getLaundryService();
                                    break;
                                }
                              }
                            },
                            items: <String>[
                              'Food Orders',
                              'Room Service',
                              'Laundry Service'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columnSpacing:
                                MediaQuery.of(context).size.width * 0.05,
                            columns: getDataColumns(
                                guestController.selectedService.value),
                            rows: guestController.serviceOrderList
                                .asMap()
                                .map((index, guest) {
                                  guest['sr_no'] = (index + 1).toString();
                                  return MapEntry(
                                      index,
                                      DataRow(
                                          cells: getDataCells(
                                              guestController
                                                  .selectedService.value,
                                              guest,
                                              index)));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'services_controller.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({super.key});
  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final ServicesController guestController = Get.put(ServicesController());

  @override
  void initState() {
    guestController.getFoodOrders();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    DateTime checkOutDate = format.parse(checkOut);
    DateTime now = DateTime.now();
    return checkOutDate.isBefore(now);
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  List<DataColumn> getDataColumns(String serviceType) {
    switch (serviceType) {
      case 'Food Orders':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Food Name')),
        ];
      case 'Room Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      case 'Laundry Service':
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
          DataColumn(label: Text('Details')),
        ];
      default:
        return const [
          DataColumn(label: Text('Sr.No')),
          DataColumn(label: Text('Guest Name')),
          DataColumn(label: Text('Date Time')),
          DataColumn(label: Text('Room No')),
          DataColumn(label: Text('Service Status')),
        ];
    }
  }

  List<DataCell> getDataCells(
      String serviceType, Map<String, dynamic> guest, int index) {
    String serviceStatus = guest['service_status'] ?? 'pending';
    return [
      DataCell(Text(guest['sr_no'] ?? 'N/A')),
      DataCell(Text(guest['guest_name'] ?? 'N/A',
          style: TextStyle(color: Colors.white))),
      DataCell(Text(guest['date_time'] ?? 'N/A',
          style: TextStyle(color: Colors.white))),
      DataCell(Text(guest['room_no'] ?? 'N/A')),
      DataCell(DropdownButton<String>(
        value: serviceStatus,
        items: <String>['pending', 'In Progress', 'Done']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                  color: value.toString().contains('pending')
                      ? Colors.red
                      : value.toString().contains('In Progress')
                          ? Colors.amber
                          : Colors.green),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) async {
          if (newValue != null) {
            setState(() {
              guest['service_status'] = newValue;
            });
            await updateServiceStatus(index, newValue, serviceType);
          }
        },
      )),
      if (serviceType == 'Food Orders')
        DataCell(Text(guest['food_name'] ?? 'N/A',
            style: TextStyle(color: Colors.white))),
      if (serviceType == 'Room Service')
        DataCell(Text(guest['details'] ?? '',
            style: TextStyle(color: Colors.white))),
      if (serviceType == 'Laundry Service')
        DataCell(Text(
            (guest['List_of_laundry'] != null
                ? guest['List_of_laundry']
                    .map((item) => '${item['name']} x${item['quantity']}')
                    .join(', ')
                : ''),
            style: TextStyle(color: Colors.white))),
    ];
  }

  Future<void> updateServiceStatus(
      int index, String newStatus, String serviceType) async {
    try {
      // Get the document
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('hotel_services')
          .doc('services')
          .get();
      if (documentSnapshot.exists) {
        List<dynamic> serviceOrderList;
        switch (serviceType) {
          case 'Food Orders':
            serviceOrderList = documentSnapshot.get('food_orders');
            break;
          case 'Room Service':
            serviceOrderList = documentSnapshot.get('room_services');
            break;
          case 'Laundry Service':
            serviceOrderList = documentSnapshot.get('laundry_services');
            break;
          default:
            serviceOrderList = [];
        }
        if (index >= 0 && index < serviceOrderList.length) {
          serviceOrderList[index]['service_status'] = newStatus;
          // Update the document
          await FirebaseFirestore.instance
              .collection('hotel_services')
              .doc('services')
              .update({
            'food_orders':
                serviceType == 'Food Orders' ? serviceOrderList : null,
            'room_services':
                serviceType == 'Room Service' ? serviceOrderList : null,
            'laundry_services':
                serviceType == 'Laundry Service' ? serviceOrderList : null,
          });
          print('Document updated successfully');
        } else {
          print('Index out of range');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.serviceOrderList.isEmpty
            ? Center(child: Text('No Data Found !!'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text('Services List',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.018)),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: guestController.selectedService.value,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.white),
                            underline: Container(),
                            dropdownColor: Colors.grey[800],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  guestController.selectedService.value =
                                      newValue;
                                });
                                switch (newValue) {
                                  case 'Food Orders':
                                    guestController.getFoodOrders();
                                    break;
                                  case 'Room Service':
                                    guestController.getRoomServiceOrder();
                                    break;
                                  case 'Laundry Service':
                                    guestController.getLaundryService();
                                    break;
                                }
                              }
                            },
                            items: <String>[
                              'Food Orders',
                              'Room Service',
                              'Laundry Service'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columnSpacing:
                                MediaQuery.of(context).size.width * 0.05,
                            columns: getDataColumns(
                                guestController.selectedService.value),
                            rows: guestController.serviceOrderList
                                .asMap()
                                .map((index, guest) {
                                  guest['sr_no'] = (index + 1).toString();
                                  return MapEntry(
                                      index,
                                      DataRow(
                                          cells: getDataCells(
                                              guestController
                                                  .selectedService.value,
                                              guest,
                                              index)));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/







/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webdextro/constants.dart';
import 'package:intl/intl.dart';

import 'edit_guest.dart';
import 'guest_list_controller.dart';

class GuestMemberList extends StatefulWidget {
  const GuestMemberList({super.key});

  @override
  State<GuestMemberList> createState() => _GuestMemberListState();
}

class _GuestMemberListState extends State<GuestMemberList> {
  final GuestController guestController = Get.put(GuestController());

  @override
  void initState() {
    guestController.LoadData();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    // Parse the check-out date
    DateTime checkOutDate = format.parse(checkOut);
    // Get the current date and time
    DateTime now = DateTime.now();

    // Check if the checkout date is earlier than the current date and time
    return checkOutDate
        .isBefore(now); // Returns true if checkout is in the past
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      // Handle successful deletion here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      // Handle errors here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: guestController.guests.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Guest List',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.018)),
                  ),
                  Expanded(
                    child: Obx(() {
                      return SingleChildScrollView(
                        child: DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.05,
                          columns: const [
                            DataColumn(label: Text('Sr.No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Check In')),
                            DataColumn(label: Text('Check Out')),
                            DataColumn(label: Text('Room\nNo')),
                            DataColumn(label: Text('Edit')),
                            DataColumn(label: Text('Delete')),
                            DataColumn(label: Text('Login\nQR code')),
                          ],
                          rows: guestController.guests
                              .asMap()
                              .map((index, guest) {
                                print(guestController.isActive.value);
                                guestController.isActive[index] =
                                    isCheckoutDatePast(guest['check_out']);
                                return MapEntry(
                                    index,
                                    DataRow(cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(Text(
                                        guest['username'],
                                        style: TextStyle(
                                          color: guestController.isActive[index]
                                              ? Colors.red
                                              : Colors.white,
                                          decorationThickness: 2,
                                          decorationColor: Colors.red,
                                          decoration:
                                              guestController.isActive[index]
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                        ),
                                      )),
                                      DataCell(Text(
                                        guest['check_in'],
                                        style: TextStyle(
                                            color:
                                                guestController.isActive[index]
                                                    ? Colors.red
                                                    : Colors.white),
                                      )),
                                      DataCell(Text(
                                        guest['check_out'],
                                        style: TextStyle(
                                            color:
                                                guestController.isActive[index]
                                                    ? Colors.red
                                                    : Colors.white),
                                      )),
                                      DataCell(Text(guest['room_no'])),
                                      DataCell(IconButton(
                                          onPressed: () {
                                            if (!guestController
                                                .isActive[index]) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditGuestPage(
                                                            data: guest,
                                                            docId:
                                                                guest['doc_id'],
                                                          )));
                                            }

                                            // Implement your edit action
                                          },
                                          icon: Icon(Icons.edit,
                                              color: guestController
                                                      .isActive[index]
                                                  ? Colors.white
                                                      .withOpacity(0.4)
                                                  : Colors.white))),
                                      DataCell(IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Confirm Delete'),
                                                  content: Text(
                                                      'Are you sure you want to delete this guest?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        // Dismiss the dialog but don't delete anything
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        // Perform the deletion operation here
                                                        // For now, we'll just close the dialog
                                                        Navigator.of(context)
                                                            .pop();
                                                        deleteGuestUser(context,
                                                            guest['doc_id']);
                                                      },
                                                      child: Text('Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            // Implement your delete action
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.red))),
                                      DataCell(
                                        IconButton(
                                            onPressed: () {
                                              if (!guestController
                                                  .isActive[index]) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    content: Container(
                                                      height: 200,
                                                      width: 200,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: QrImageView(
                                                          data:
                                                              'https://autosys-user-dashboard-login.web.app/?refId=${guest['doc_id']}',
                                                          version:
                                                              QrVersions.auto,
                                                          size: 200,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              // Implement your delete action
                                            },
                                            icon: Icon(Icons.qr_code,
                                                color: guestController
                                                        .isActive[index]
                                                    ? Colors.white
                                                        .withOpacity(0.4)
                                                    : Colors.white)),
                                      ),
                                    ]));
                              })
                              .values
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
*/

/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webdextro/constants.dart';
import 'package:intl/intl.dart';
import '../../controllers/MenuAppController.dart';
import '../Auth/login.dart';
import '../dashboard/components/header.dart';
import 'guest_list_controller.dart';
import '../main/components/side_menu.dart';
import 'edit_guest.dart';

class GuestMemberList extends StatefulWidget {
  const GuestMemberList({super.key});

  @override
  State<GuestMemberList> createState() => _GuestMemberListState();
}

class _GuestMemberListState extends State<GuestMemberList> {
  final GuestController guestController = Get.put(GuestController());

  @override
  void initState() {
    guestController.LoadData();
    super.initState();
  }

  bool isCheckoutDatePast(String checkOut) {
    DateFormat format = DateFormat("EEE, d'th' MMM yy hh:mm a");
    DateTime checkOutDate = format.parse(checkOut);
    DateTime now = DateTime.now();
    return checkOutDate.isBefore(now);
  }

  void deleteGuestUser(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('guest_user')
        .doc(docId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Document successfully deleted!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete document: $error',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: context.read<MenuAppController>().scaffoldKey,
        drawer: Drawer(
          backgroundColor: secondaryColor,
          child: ListView(
            children: [
              DrawerHeader(
                child: Image.asset(
                  "assets/images/appLogo.png",
                  fit: BoxFit.cover,
                ),
              ),
              DrawerListTile(
                index: 0,
                selectedindex: 1, // Update this based on the current page index
                title: "Dashboard",
                icon: Icon(Icons.home_filled),
                press: () {
                  Get.toNamed('/dashboard'); // Navigate to the dashboard
                },
              ),
              DrawerListTile(
                index: 1,
                selectedindex: 1, // Update this based on the current page index
                title: "Analytics",
                icon: Icon(Icons.bar_chart_rounded),
                press: () {
                  Get.toNamed('/analytics'); // Navigate to the analytics page
                },
              ),
              DrawerListTile(
                index: 2,
                selectedindex: 1, // Update this based on the current page index
                title: "Add Guest",
                icon: Icon(Icons.person_add_alt_1),
                press: () {
                  Get.toNamed('/add_guest'); // Navigate to Add Guest Page
                },
              ),
              DrawerListTile(
                index: 3,
                selectedindex: 1, // Update this based on the current page index
                title: "Guest List",
                icon: Icon(Icons.person_add_alt_1),
                press: () {
                  // Already on Guest List Page
                },
              ),
              DrawerListTile(
                index: 4,
                selectedindex: 1, // Update this based on the current page index
                title: "Services",
                icon: Icon(Icons.meeting_room_rounded),
                press: () {
                  Get.toNamed('/services'); // Navigate to Services Page
                },
              ),
              DrawerListTile(
                index: 5,
                selectedindex: 1, // Update this based on the current page index
                title: "Logout",
                icon: Icon(
                  Icons.logout,
                ),
                press: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                            },
                          ),
                          TextButton(
                            child: Text('Logout'),
                            onPressed: () {
                              Navigator.pop(context);
                              Hive.box('boxData').clear();
                              Get.offAll(
                                  () => Login()); // Navigate to Login Page
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Header(),
              guestController.guests.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.05,
                          columns: const [
                            DataColumn(label: Text('Sr.No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Check In')),
                            DataColumn(label: Text('Check Out')),
                            DataColumn(label: Text('Room\nNo')),
                            DataColumn(label: Text('Edit')),
                            DataColumn(label: Text('Delete')),
                            DataColumn(label: Text('Login\nQR code')),
                          ],
                          rows: guestController.guests
                              .asMap()
                              .map((index, guest) {
                                guestController.isActive[index] =
                                    isCheckoutDatePast(guest['check_out']);
                                return MapEntry(
                                    index,
                                    DataRow(cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(Text(
                                        guest['username'],
                                        style: TextStyle(
                                          color: guestController.isActive[index]
                                              ? Colors.red
                                              : Colors.white,
                                          decorationThickness: 2,
                                          decorationColor: Colors.red,
                                          decoration:
                                              guestController.isActive[index]
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                        ),
                                      )),
                                      DataCell(Text(
                                        guest['check_in'],
                                        style: TextStyle(
                                            color:
                                                guestController.isActive[index]
                                                    ? Colors.red
                                                    : Colors.white),
                                      )),
                                      DataCell(Text(
                                        guest['check_out'],
                                        style: TextStyle(
                                            color:
                                                guestController.isActive[index]
                                                    ? Colors.red
                                                    : Colors.white),
                                      )),
                                      DataCell(Text(guest['room_no'])),
                                      DataCell(IconButton(
                                          onPressed: () {
                                            if (!guestController
                                                .isActive[index]) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditGuestPage(
                                                            data: guest,
                                                            docId:
                                                                guest['doc_id'],
                                                          )));
                                            }
                                          },
                                          icon: Icon(Icons.edit,
                                              color: guestController
                                                      .isActive[index]
                                                  ? Colors.white
                                                      .withOpacity(0.4)
                                                  : Colors.white))),
                                      DataCell(IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Confirm Delete'),
                                                  content: Text(
                                                      'Are you sure you want to delete this guest?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        deleteGuestUser(context,
                                                            guest['doc_id']);
                                                      },
                                                      child: Text('Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.red))),
                                      DataCell(
                                        IconButton(
                                            onPressed: () {
                                              if (!guestController
                                                  .isActive[index]) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    content: Container(
                                                      height: 200,
                                                      width: 200,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: QrImageView(
                                                          data:
                                                              'https://autosys-user-dashboard-login.web.app/?refId=${guest['doc_id']}',
                                                          version:
                                                              QrVersions.auto,
                                                          size: 200,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: Icon(Icons.qr_code,
                                                color: guestController
                                                        .isActive[index]
                                                    ? Colors.white
                                                        .withOpacity(0.4)
                                                    : Colors.white)),
                                      ),
                                    ]));
                              })
                              .values
                              .toList(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
*/



/*
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants.dart';
import '../Auth/login.dart';
import '../main/components/side_menu.dart';
import 'graphs/bar_chart_one.dart';
import 'graphs/biggest_bar_chart.dart';
import 'graphs/line_graph.dart';
import 'graphs/pie_chart.dart';
import 'graphs/small_bar_graph.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoBox(
                    'Watts used',
                    '108Kwh',
                    'This month',
                    'assets/images/Vector 13.png',
                    Icons.arrow_downward_sharp,
                    '-6.8%',
                    Color.fromARGB(255, 66, 167, 30),
                    screenWidth,
                    screenHeight,
                  ),
                  infoBox(
                    'Lights on',
                    '85mins',
                    'This month',
                    'assets/images/Vector.png',
                    Icons.arrow_downward_sharp,
                    '-4.8%',
                    Color.fromARGB(255, 66, 167, 30),
                    screenWidth,
                    screenHeight,
                  ),
                  infoBox(
                    'Fans on',
                    '46mins',
                    'This month',
                    'assets/images/Frame.png',
                    Icons.arrow_upward_sharp,
                    '+3.6%',
                    Color.fromARGB(255, 211, 25, 25),
                    screenWidth,
                    screenHeight,
                  ),
                  infoBox(
                    'Your',
                    'Carbon Footprint',
                    'This month',
                    'assets/images/Group 444.png',
                    Icons.arrow_upward_sharp,
                    '+9.6%',
                    Color.fromARGB(255, 211, 25, 25),
                    screenWidth,
                    screenHeight,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BarChartExamples(), // Assuming Chart is another widget
                    SizedBox(width: 15.0),
                    PieChartSample(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  child: Row(
                    children: [
                      SmallBarChart(),
                      SizedBox(width: 15.0),
                      Chart(), // Assuming Chart is another widget
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BiggestBar() // Assuming Chart is another widget
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoBox(
    String title,
    String value,
    String subtitle,
    String imagePath,
    IconData icon,
    String iconText,
    Color iconColor,
    double screenWidth,
    double screenHeight,
  ) {
    final double fontSize = screenWidth * 0.005;
    final double boxHeight =
        screenWidth * 0.100; // Adjust box height proportionally to width

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.01),
      child: Container(
        height: boxHeight, // Use proportional height
        //width: screenWidth * 0.205,
        width: screenWidth * 0.180,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color.fromARGB(255, 89, 89, 89),
              width: 2,
            )),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: boxHeight * 0.40, // Position based on proportional height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize * 1.5,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    value,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 187, 0),
                      fontSize: screenWidth * 0.013,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 122, 122),
                      fontSize: fontSize * 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: boxHeight * 0.15, // Adjust position proportionally
              child: Column(
                children: [
                  imagebox(imagePath, screenWidth, screenHeight),
                  SizedBox(
                      height:
                          boxHeight * 0.15), // Spacing proportional to height
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: iconColor,
                        size: screenWidth * 0.011,
                      ),
                      SizedBox(width: 5),
                      Text(
                        iconText,
                        style: TextStyle(
                          color: iconColor,
                          fontSize: screenWidth * 0.011,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imagebox(String imagePath, double screenWidth, double screenHeight) {
    final double height = screenHeight * 0.05;
    final double width = screenWidth * 0.04;
    //final double boxHeight = screenWidth * 0.02;
    final double imageSize = screenWidth * 0.04;
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xff232323),
      ),
      child: Image.asset(
        imagePath,
        color: Colors.white,
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants.dart';
import '../Auth/login.dart';
import '../main/components/side_menu.dart';
import '../../controllers/MenuAppController.dart';
import 'graphs/bar_chart_one.dart';
import 'graphs/biggest_bar_chart.dart';
import 'graphs/line_graph.dart';
import 'graphs/pie_chart.dart';
import 'graphs/small_bar_graph.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final MenuAppController menuController = Get.put(MenuAppController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: menuController.scaffoldKey,
      drawer: Drawer(
        backgroundColor: secondaryColor,
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset(
                "assets/images/appLogo.png",
                fit: BoxFit.cover,
              ),
            ),
            DrawerListTile(
              index: 0,
              selectedindex: 1, // Update this based on the current page index
              title: "Dashboard",
              icon: Icon(Icons.home_filled),
              press: () {
                Get.toNamed('/dashboard'); // Navigate to the dashboard
              },
            ),
            DrawerListTile(
              index: 1,
              selectedindex: 1, // Update this based on the current page index
              title: "Analytics",
              icon: Icon(Icons.bar_chart_rounded),
              press: () {
                // Already on Analytics Page
              },
            ),
            DrawerListTile(
              index: 2,
              selectedindex: 1, // Update this based on the current page index
              title: "Add Guest",
              icon: Icon(Icons.person_add_alt_1),
              press: () {
                Get.toNamed('/add_guest'); // Navigate to Add Guest Page
              },
            ),
            DrawerListTile(
              index: 3,
              selectedindex: 1, // Update this based on the current page index
              title: "Guest List",
              icon: Icon(Icons.person_add_alt_1),
              press: () {
                Get.toNamed('/guest_list'); // Navigate to Guest List Page
              },
            ),
            DrawerListTile(
              index: 4,
              selectedindex: 1, // Update this based on the current page index
              title: "Services",
              icon: Icon(Icons.meeting_room_rounded),
              press: () {
                Get.toNamed('/services'); // Navigate to Services Page
              },
            ),
            DrawerListTile(
              index: 5,
              selectedindex: 1, // Update this based on the current page index
              title: "Logout",
              icon: Icon(
                Icons.logout,
              ),
              press: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss the dialog
                          },
                        ),
                        TextButton(
                          child: Text('Logout'),
                          onPressed: () {
                            Navigator.pop(context);
                            Hive.box('boxData').clear();
                            Get.offAll(() => Login()); // Navigate to Login Page
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      infoBox(
                        'Watts used',
                        '108Kwh',
                        'This month',
                        'assets/images/Vector 13.png',
                        Icons.arrow_downward_sharp,
                        '-6.8%',
                        Color.fromARGB(255, 66, 167, 30),
                        screenWidth,
                        screenHeight,
                      ),
                      infoBox(
                        'Lights on',
                        '85mins',
                        'This month',
                        'assets/images/Vector.png',
                        Icons.arrow_downward_sharp,
                        '-4.8%',
                        Color.fromARGB(255, 66, 167, 30),
                        screenWidth,
                        screenHeight,
                      ),
                      infoBox(
                        'Fans on',
                        '46mins',
                        'This month',
                        'assets/images/Frame.png',
                        Icons.arrow_upward_sharp,
                        '+3.6%',
                        Color.fromARGB(255, 211, 25, 25),
                        screenWidth,
                        screenHeight,
                      ),
                      infoBox(
                        'Your',
                        'Carbon Footprint',
                        'This month',
                        'assets/images/Group 444.png',
                        Icons.arrow_upward_sharp,
                        '+9.6%',
                        Color.fromARGB(255, 211, 25, 25),
                        screenWidth,
                        screenHeight,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        BarChartExamples(), // Assuming Chart is another widget
                        SizedBox(width: 15.0),
                        PieChartSample(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      child: Row(
                        children: [
                          SmallBarChart(),
                          SizedBox(width: 15.0),
                          Chart(), // Assuming Chart is another widget
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        BiggestBar() // Assuming Chart is another widget
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoBox(
    String title,
    String value,
    String subtitle,
    String imagePath,
    IconData icon,
    String iconText,
    Color iconColor,
    double screenWidth,
    double screenHeight,
  ) {
    final double fontSize = screenWidth * 0.005;
    final double boxHeight =
        screenWidth * 0.100; // Adjust box height proportionally to width

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.01),
      child: Container(
        height: boxHeight, // Use proportional height
        //width: screenWidth * 0.205,
        width: screenWidth * 0.180,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color.fromARGB(255, 89, 89, 89),
              width: 2,
            )),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: boxHeight * 0.40, // Position based on proportional height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize * 1.5,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    value,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 187, 0),
                      fontSize: screenWidth * 0.013,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 122, 122),
                      fontSize: fontSize * 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: boxHeight * 0.15, // Adjust position proportionally
              child: Column(
                children: [
                  imagebox(imagePath, screenWidth, screenHeight),
                  SizedBox(
                      height:
                          boxHeight * 0.15), // Spacing proportional to height
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: iconColor,
                        size: screenWidth * 0.011,
                      ),
                      SizedBox(width: 5),
                      Text(
                        iconText,
                        style: TextStyle(
                          color: iconColor,
                          fontSize: screenWidth * 0.011,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imagebox(String imagePath, double screenWidth, double screenHeight) {
    final double height = screenHeight * 0.05;
    final double width = screenWidth * 0.04;
    //final double boxHeight = screenWidth * 0.02;
    final double imageSize = screenWidth * 0.04;
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xff232323),
      ),
      child: Image.asset(
        imagePath,
        color: Colors.white,
      ),
    );
  }
}
*/


/*
import 'package:flutter/material.dart';
import 'package:webdextro/screens/dashboard/components/weatherCard.dart';

import '../../../constants.dart';
import '../../../models/MyFiles.dart';
import '../../../responsive.dart';
import 'activeDevices.dart';
import 'calendar.dart';
import 'file_info_card.dart';
import 'weather_card.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           "Hi John!",
        //           style: Theme.of(context)
        //               .textTheme
        //               .displaySmall!
        //               .copyWith(color: Colors.white),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(4.0),
        //           child: Text(
        //             "Your energy consumption is higher today than other days",
        //             style: Theme.of(context).textTheme.labelSmall,
        //           ),
        //         ),
        //       ],
        //     ),

        //   ],
        // ),
        // SizedBox(height: defaultPadding),
        

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
                height: 320,
                width:
                    _size.width < 600 ? _size.width * 0.29 : _size.width * 0.28,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi John!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.025)),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                              "Your energy consumption is higher today than other days",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 200,
                        width: _size.width < 600
                            ? _size.width * 0.3
                            : _size.width * 0.31,
                        child: ProgressCard()),
                  ],
                )),
            SizedBox(
                height: 310,
                width:
                    _size.width < 600 ? _size.width * 0.24 : _size.width * 0.2,
                child: CalendarPage()),
            SizedBox(
                height: 330,
                width:
                    _size.width < 600 ? _size.width * 0.26 : _size.width * 0.25,
                child: WeatherCardsReport()),

            // Responsive(
            //   mobile: FileInfoCardGridView(
            //     crossAxisCount: _size.width < 650 ? 2 : 4,
            //     childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
            //   ),
            //   tablet: FileInfoCardGridView(),
            //   desktop: FileInfoCardGridView(
            //     childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          Container(width: 400, child: FileInfoCard(info: demoMyFiles[index])),
    );
  }
}
*/