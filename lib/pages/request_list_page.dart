import 'package:flutter/material.dart';
import 'package:ower_project/models/request.dart';

class RequestListPage extends StatefulWidget {
  final List<ServiceRequest> requests;

  const RequestListPage({super.key, required this.requests});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 11, 53, 87)),
        centerTitle: true,
        title: const Text(
          "My Requests",
          style: TextStyle(
            color: Color.fromARGB(255, 11, 53, 87),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.requests.isEmpty
            ? const Center(
                child: Text(
                  "No requests submitted yet.",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: widget.requests.length,
                itemBuilder: (context, index) {
                  final req = widget.requests[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        req.serviceType,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 70, 17, 1)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text("${req.fullName}\n${req.description}",
                              maxLines: 3, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 5),
                          Text(
                            req.isAccepted ? "Status: Accepted" : "Status: Pending",
                            style: TextStyle(
                              color: req.isAccepted ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(
                          req.isAccepted
                              ? Icons.check_circle
                              : Icons.hourglass_top,
                          color: req.isAccepted ? Colors.green : Colors.orange,
                        ),
                        onPressed: () {
                          setState(() {
                            req.isAccepted = !req.isAccepted; // تغيير الحالة
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
