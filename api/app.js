// Import dependencies
const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql");
const cors = require("cors");
require("dotenv").config();

// Create Express app
const app = express();
app.use(cors()); // Tambahkan ini
const port = 3000;

// Middleware
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 3306, // Jika DB_PORT tidak ada, gunakan port default 3306
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    console.error("Database connection failed:", err);
    process.exit(1);
  }
  console.log("Connected to MySQL database.");
});

// Routes for 'barang'
app.get("/barang", (req, res) => {
  db.query("SELECT * FROM barang", (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});
app.get("/barang/:no_barcode", (req, res) => {
  const { no_barcode } = req.params;

  db.query(
    "SELECT * FROM barang WHERE no_barcode = ?",
    [no_barcode],
    (err, results) => {
      if (err) {
        // Jika terjadi error pada query
        return res.status(500).json({ error: err.message });
      }

      if (results.length > 0) {
        // Jika barang ditemukan
        res.json({ message: "Barang ditemukan", data: results[0] });
      } else {
        // Jika barang tidak ditemukan
        res.status(404).json({ message: "Barang tidak ada" });
      }
    }
  );
});

app.post("/barang", (req, res) => {
  const { no_barcode, nama, harga, stok } = req.body;
  db.query(
    "INSERT INTO barang SET ?",
    { no_barcode, nama, harga, stok },
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res
        .status(201)
        .json({ message: "Barang added successfully", id: results.insertId });
    }
  );
});

app.put("/barang/:no_barcode", (req, res) => {
  const { no_barcode } = req.params;
  const { nama, harga, stok } = req.body;
  db.query(
    "UPDATE barang SET ? WHERE no_barcode = ?",
    [{ nama, harga, stok }, no_barcode],
    (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Barang updated successfully" });
    }
  );
});

app.delete("/barang/:no_barcode", (req, res) => {
  const { no_barcode } = req.params;
  db.query("DELETE FROM barang WHERE no_barcode = ?", [no_barcode], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Barang deleted successfully" });
  });
});

// Routes for 'supplier'
app.get("/supplier", (req, res) => {
  db.query("SELECT * FROM supplier", (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.post("/supplier", (req, res) => {
  const { id_sup, nama, alamat, no_hp } = req.body;
  db.query(
    "INSERT INTO supplier SET ?",
    { id_sup, nama, alamat, no_hp },
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res
        .status(201)
        .json({ message: "Supplier added successfully", id: results.insertId });
    }
  );
});

app.put("/supplier/:id_sup", (req, res) => {
  const { id_sup } = req.params;
  const { nama, alamat, no_hp } = req.body;
  db.query(
    "UPDATE supplier SET ? WHERE id_sup = ?",
    [{ nama, alamat, no_hp }, id_sup],
    (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Supplier updated successfully" });
    }
  );
});

app.delete("/supplier/:id_sup", (req, res) => {
  const { id_sup } = req.params;
  db.query("DELETE FROM supplier WHERE id_sup = ?", [id_sup], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Supplier deleted successfully" });
  });
});

// Routes for 'penjualan'
app.get("/penjualan", (req, res) => {
  db.query(
    "SELECT * FROM penjualan JOIN barang ON penjualan.no_barcode = barang.no_barcode",
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json(results);
    }
  );
});

app.post("/penjualan", (req, res) => {
  const { no_nota, no_barcode, jumlah } = req.body;

  // Periksa apakah barang ada dan stok mencukupi
  db.query(
    "SELECT stok FROM barang WHERE no_barcode = ?",
    [no_barcode],
    (err, results) => {
      if (err) return res.status(500).json({ error: err.message });

      // Jika barang tidak ditemukan
      if (results.length === 0) {
        return res.status(404).json({ error: "Barang tidak ditemukan" });
      }

      const stokSaatIni = results[0].stok;

      // Jika stok tidak mencukupi
      if (stokSaatIni < jumlah) {
        return res.status(400).json({ error: "Stok tidak mencukupi" });
      }

      // Kurangi stok barang
      const stokBaru = stokSaatIni - jumlah;
      db.query(
        "UPDATE barang SET stok = ? WHERE no_barcode = ?",
        [stokBaru, no_barcode],
        (err) => {
          if (err) return res.status(500).json({ error: err.message });

          // Simpan transaksi penjualan
          db.query(
            "INSERT INTO penjualan SET ?",
            { no_nota, no_barcode, jumlah },
            (err, results) => {
              if (err) return res.status(500).json({ error: err.message });

              res.status(201).json({
                message: "Penjualan added successfully",
                id: results.insertId,
              });
            }
          );
        }
      );
    }
  );
});

app.put("/penjualan/:no_nota", (req, res) => {
  const { no_nota } = req.params;
  const { no_barcode, jumlah } = req.body;
  db.query(
    "UPDATE penjualan SET ? WHERE no_nota = ?",
    [{ no_barcode, jumlah }, no_nota],
    (err) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "Penjualan updated successfully" });
    }
  );
});

app.delete("/penjualan/:no_nota", (req, res) => {
  const { no_nota } = req.params;
  db.query("DELETE FROM penjualan WHERE no_nota = ?", [no_nota], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Penjualan deleted successfully" });
  });
});

// Start server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
