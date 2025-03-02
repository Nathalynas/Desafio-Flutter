import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Color(0xFF581845),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}

// Tela de Login estilizada
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _stayConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/logo.png', height: 150), // Ajuste para o logo
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bem-vindo, por favor informe seus dados de acesso.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Checkbox(
                    value: _stayConnected,
                    onChanged: (value) {
                      setState(() {
                        _stayConnected = value ?? false;
                      });
                    },
                    activeColor: Colors.deepPurple,
                  ),
                  Text('Manter-me conectado'),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF581845),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListScreen(),
                    ),
                  );
                },
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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

// Tela de Cadastro de Produto
class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '0',
  );
  final TextEditingController _priceController = TextEditingController(
    text: 'R\$ 0,00',
  );
  String _selectedCategory = 'Vestido';
  int _productCode = DateTime.now().millisecondsSinceEpoch % 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Produtos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF581845),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF581845)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Código',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              TextField(
                                controller:
                                    _codeController, // Agora permite edição
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Categoria',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items:
                          ['Vestido', 'Calça', 'Camiseta'].map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantidade',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Valor de Venda',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Apenas números
                                ],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    return;
                                  }

                                  String cleanedValue = value.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  );

                                  double parsedValue =
                                      double.tryParse(cleanedValue) ?? 0;

                                  String formattedValue =
                                      'R\$ ' +
                                      NumberFormat(
                                        '#,##0.00',
                                        'pt_BR',
                                      ).format(parsedValue / 100);

                                  if (formattedValue != _priceController.text) {
                                    _priceController.value = TextEditingValue(
                                      text: formattedValue,
                                      selection: TextSelection.collapsed(
                                        offset: formattedValue.length,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF581845),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<ProductProvider>(
                            context,
                            listen: false,
                          ).addProduct({
                            'id':
                                int.tryParse(_codeController.text) ??
                                _productCode, // Usa o valor do campo Código
                            'name': _nameController.text,
                            'category': _selectedCategory,
                            'quantity':
                                int.tryParse(_quantityController.text) ?? 0,
                            'price': _priceController.text,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Produto cadastrado com sucesso!'),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          Future.delayed(Duration(milliseconds: 500), () {
                            Navigator.pop(
                              context,
                            ); // Aguarda meio segundo antes de voltar
                          });
                        },

                        child: Text(
                          'Salvar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Tela de Listagem de Produtos
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove a seta de voltar
        title: Text(
          'Listagem de Produtos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF581845)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              size: 30,
              color: Color(0xFF581845),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF581845),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductFormScreen()),
                );
              },
              child: Text(
                'Novo Produto',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Permite rolagem lateral caso necessário
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.vertical, // Permite rolagem vertical caso necessário
                  child: Consumer<ProductProvider>(
                    builder: (context, provider, child) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth:
                              MediaQuery.of(
                                context,
                              ).size.width, // Ocupa toda a largura disponível
                        ),
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: MaterialStateProperty.all(
                            Color(0xFF581845),
                          ),
                          dataRowColor: MaterialStateProperty.all(Colors.white),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Código',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Nome',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Categoria',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Quantidade',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Ações',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          rows:
                              provider.products.map((product) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        product['id'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        product['name'].toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF581845),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(product['category'].toUpperCase()),
                                    ),
                                    DataCell(
                                      Text(
                                        product['quantity'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF581845),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.grey[700],
                                            ),
                                            onPressed: () {
                                              // Função para editar
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              provider.deleteProduct(
                                                product['id'],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Provider para gerenciamento de produtos
class ProductProvider with ChangeNotifier {
  List<Map<String, dynamic>> _products = [
    {'id': 1, 'name': 'VESTIDO LUNA', 'category': 'VESTIDO', 'quantity': 12},
    {'id': 2, 'name': 'CALÇA ZIG', 'category': 'CALÇA', 'quantity': 5},
  ];

  List<Map<String, dynamic>> get products => _products;

  // Método para adicionar um produto
  void addProduct(Map<String, dynamic> product) {
    _products.add(product);
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  void deleteProduct(int id) {
    _products.removeWhere((product) => product['id'] == id);
    notifyListeners();
  }
}
