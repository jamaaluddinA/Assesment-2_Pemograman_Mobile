<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

include_once 'config.php';
include_once 'products.php';

$database = new Database();
$db = $database->getConnection();
$product = new Product($db);

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET' && isset($_GET['init'])) {
    if($product->createTable()) {
        echo json_encode(array("message" => "Table created successfully."));
    } else {
        echo json_encode(array("message" => "Unable to create table."));
    }
    exit();
}

// ✅ TEST ENDPOINT
if ($method == 'GET' && isset($_GET['test'])) {
    echo json_encode(array(
        "success" => true,
        "message" => "PHP API is working!",
        "database" => "Connected to MySQL"
    ));
    exit();
}

switch($method) {
    case 'GET':
        if(isset($_GET['id'])) {
            // Get single product
            $product->id = $_GET['id'];
            if($product->readOne()) {
                $product_arr = array(
                    "id" => (int)$product->id,
                    "name" => $product->name,
                    "category" => $product->category,
                    "imagePath" => $product->imagePath,
                    "description" => $product->description,
                    "price" => (float)$product->price,
                    "quantity" => (int)$product->quantity
                );
                http_response_code(200);
                echo json_encode($product_arr);
            } else {
                http_response_code(404);
                echo json_encode(array("message" => "Product not found."));
            }
        } else {
            // ✅ GET ALL PRODUCTS - PASTIKAN FORMAT INI
            $stmt = $product->read();
            if($stmt) {
                $products_arr = array();
                $products_arr["data"] = array(); // ✅ KEY "data" HARUS ADA
                
                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    $product_item = array(
                        "id" => (int)$row['id'],
                        "name" => $row['name'],
                        "category" => $row['category'],
                        "imagePath" => $row['imagePath'],
                        "description" => $row['description'],
                        "price" => (float)$row['price'],
                        "quantity" => (int)$row['quantity']
                    );
                    array_push($products_arr["data"], $product_item);
                }
                
                http_response_code(200);
                echo json_encode($products_arr);
            } else {
                http_response_code(500);
                echo json_encode(array("message" => "Unable to read products."));
            }
        }
        break;
        
    case 'POST':
        // CREATE PRODUCT
        $input = json_decode(file_get_contents("php://input"), true);
        
        if(!empty($input['name']) && !empty($input['price'])) {
            $product->name = $input['name'];
            $product->category = $input['category'] ?? '';
            $product->imagePath = $input['imagePath'] ?? '';
            $product->description = $input['description'] ?? '';
            $product->price = $input['price'];
            $product->quantity = $input['quantity'] ?? 1;
            
            $lastId = $product->create();
            
            if($lastId) {
                http_response_code(201);
                echo json_encode(array(
                    "message" => "Product created successfully.",
                    "id" => (int)$lastId
                ));
            } else {
                http_response_code(503);
                echo json_encode(array("message" => "Unable to create product."));
            }
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "Missing required data (name, price)."));
        }
        break;
        
    case 'PUT':
        // UPDATE PRODUCT
        $input = json_decode(file_get_contents("php://input"), true);
        
        if(!empty($input['id'])) {
            $product->id = $input['id'];
            $product->name = $input['name'] ?? '';
            $product->category = $input['category'] ?? '';
            $product->imagePath = $input['imagePath'] ?? '';
            $product->description = $input['description'] ?? '';
            $product->price = $input['price'] ?? 0;
            $product->quantity = $input['quantity'] ?? 1;
            
            if($product->update()) {
                http_response_code(200);
                echo json_encode(array("message" => "Product updated successfully."));
            } else {
                http_response_code(503);
                echo json_encode(array("message" => "Unable to update product."));
            }
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "Missing product ID."));
        }
        break;
        
    case 'DELETE':
        // DELETE PRODUCT
        $input = json_decode(file_get_contents("php://input"), true);
        
        if(!empty($input['id'])) {
            $product->id = $input['id'];
            
            if($product->delete()) {
                http_response_code(200);
                echo json_encode(array("message" => "Product deleted successfully."));
            } else {
                http_response_code(503);
                echo json_encode(array("message" => "Unable to delete product."));
            }
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "Missing product ID."));
        }
        break;
        
    default:
        http_response_code(405);
        echo json_encode(array("message" => "Method not allowed."));
        break;
}
?>