<?php
include_once 'config.php';

class Product {
    private $conn;
    private $table_name = "products";

    public $id;
    public $name;
    public $category;
    public $imagePath;
    public $description;
    public $price;
    public $quantity;

    public function __construct($db) {
        $this->conn = $db;
    }

    // CREATE TABLE (run once)
    public function createTable() {
        try {
            $query = "CREATE TABLE IF NOT EXISTS " . $this->table_name . " (
                id INT(11) AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                category VARCHAR(100) NOT NULL,
                imagePath VARCHAR(500) NOT NULL,
                description TEXT,
                price DECIMAL(10,2) NOT NULL,
                quantity INT(11) NOT NULL DEFAULT 1,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )";

            $stmt = $this->conn->prepare($query);
            $result = $stmt->execute();
            
            error_log("✅ Products table created successfully");
            return $result;
            
        } catch (PDOException $exception) {
            error_log("❌ Error creating table: " . $exception->getMessage());
            return false;
        }
    }

    // GET ALL PRODUCTS
    public function read() {
        try {
            $query = "SELECT * FROM " . $this->table_name . " ORDER BY id DESC";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            
            error_log("✅ Retrieved products from database");
            return $stmt;
            
        } catch (PDOException $exception) {
            error_log("❌ Error reading products: " . $exception->getMessage());
            return false;
        }
    }

    // GET SINGLE PRODUCT
    public function readOne() {
        try {
            $query = "SELECT * FROM " . $this->table_name . " WHERE id = ? LIMIT 0,1";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(1, $this->id);
            $stmt->execute();

            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            if($row) {
                $this->name = $row['name'];
                $this->category = $row['category'];
                $this->imagePath = $row['imagePath'];
                $this->description = $row['description'];
                $this->price = $row['price'];
                $this->quantity = $row['quantity'];
                return true;
            }
            return false;
            
        } catch (PDOException $exception) {
            error_log("❌ Error reading product: " . $exception->getMessage());
            return false;
        }
    }

    // CREATE PRODUCT
    public function create() {
        try {
            $query = "INSERT INTO " . $this->table_name . " 
                     SET name=:name, category=:category, imagePath=:imagePath, 
                         description=:description, price=:price, quantity=:quantity";

            $stmt = $this->conn->prepare($query);

            // sanitize
            $this->name = htmlspecialchars(strip_tags($this->name));
            $this->category = htmlspecialchars(strip_tags($this->category));
            $this->imagePath = htmlspecialchars(strip_tags($this->imagePath));
            $this->description = htmlspecialchars(strip_tags($this->description));
            $this->price = htmlspecialchars(strip_tags($this->price));
            $this->quantity = htmlspecialchars(strip_tags($this->quantity));

            // bind data
            $stmt->bindParam(":name", $this->name);
            $stmt->bindParam(":category", $this->category);
            $stmt->bindParam(":imagePath", $this->imagePath);
            $stmt->bindParam(":description", $this->description);
            $stmt->bindParam(":price", $this->price);
            $stmt->bindParam(":quantity", $this->quantity);

            if($stmt->execute()) {
                $lastId = $this->conn->lastInsertId();
                error_log("✅ Product created with ID: " . $lastId);
                return $lastId;
            }
            return false;
            
        } catch (PDOException $exception) {
            error_log("❌ Error creating product: " . $exception->getMessage());
            return false;
        }
    }

    // UPDATE PRODUCT
    public function update() {
        try {
            $query = "UPDATE " . $this->table_name . " 
                     SET name=:name, category=:category, imagePath=:imagePath, 
                         description=:description, price=:price, quantity=:quantity
                     WHERE id=:id";

            $stmt = $this->conn->prepare($query);

            // sanitize
            $this->name = htmlspecialchars(strip_tags($this->name));
            $this->category = htmlspecialchars(strip_tags($this->category));
            $this->imagePath = htmlspecialchars(strip_tags($this->imagePath));
            $this->description = htmlspecialchars(strip_tags($this->description));
            $this->price = htmlspecialchars(strip_tags($this->price));
            $this->quantity = htmlspecialchars(strip_tags($this->quantity));
            $this->id = htmlspecialchars(strip_tags($this->id));

            // bind data
            $stmt->bindParam(":name", $this->name);
            $stmt->bindParam(":category", $this->category);
            $stmt->bindParam(":imagePath", $this->imagePath);
            $stmt->bindParam(":description", $this->description);
            $stmt->bindParam(":price", $this->price);
            $stmt->bindParam(":quantity", $this->quantity);
            $stmt->bindParam(":id", $this->id);

            if($stmt->execute()) {
                error_log("✅ Product updated: " . $this->name);
                return true;
            }
            return false;
            
        } catch (PDOException $exception) {
            error_log("❌ Error updating product: " . $exception->getMessage());
            return false;
        }
    }

    // DELETE PRODUCT
    public function delete() {
        try {
            $query = "DELETE FROM " . $this->table_name . " WHERE id = ?";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(1, $this->id);

            if($stmt->execute()) {
                error_log("✅ Product deleted with ID: " . $this->id);
                return true;
            }
            return false;
            
        } catch (PDOException $exception) {
            error_log("❌ Error deleting product: " . $exception->getMessage());
            return false;
        }
    }
}
?>