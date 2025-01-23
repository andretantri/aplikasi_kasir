import 'package:flutter/material.dart';
import 'package:kasir/controller/penjualan_controller.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PenjualanController historyController = PenjualanController();
  List<Map<String, dynamic>> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactionHistory();
  }

  Future<void> fetchTransactionHistory() async {
    try {
      final data = await historyController.fetchHistory();
      setState(() {
        history = groupItemsByInvoice(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching history: $e')));
    }
  }

  // Function to group items by no_nota
  List<Map<String, dynamic>> groupItemsByInvoice(List<dynamic> data) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    // Group items by no_nota
    for (var item in data) {
      String invoiceNumber = item['no_nota'];
      if (!grouped.containsKey(invoiceNumber)) {
        grouped[invoiceNumber] = [];
      }
      grouped[invoiceNumber]!.add(item);
    }

    // Convert grouped data to a list of maps
    return grouped.entries.map((entry) {
      return {'no_nota': entry.key, 'items': entry.value};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Transaksi'),
        backgroundColor: Colors.green,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : history.isEmpty
              ? Center(child: Text('Tidak ada data transaksi'))
              : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final invoice = history[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '# ${invoice['no_nota']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ...invoice['items'].map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                '(Qty: ${item['jumlah']})${item['no_barcode']} - ${item['nama']}',
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
