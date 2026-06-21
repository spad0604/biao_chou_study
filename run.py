import os
import argparse
import gdown
from ultralytics import YOLO

import os
import gdown

def check_and_download_weights():
    # Đường dẫn nơi sẽ lưu file model trong dự án
    weights_path = "weights/best.pt"
    
    # 1. Kiểm tra xem file best.pt đã tồn tại ở local chưa
    if not os.path.exists(weights_path):
        print("Không tìm thấy file trọng số weights/best.pt. Đang tự động tải về từ Google Drive...")
        
        # Tạo thư mục weights nếu chưa có
        os.makedirs("weights", exist_ok=True)
        
        # 2. Điền MÃ_FILE_DÀI_NGOẰNG cậu vừa lấy ở Bước 1 vào đây nhé
        file_id = "19v6iP7NAY90H9aD4QLZhVmMaWTmE26vY"
        url = f"https://drive.google.com/uc?id={file_id}"
        
        # 3. Tiến hành tải file từ Drive xuống đúng thư mục weights
        gdown.download(url, weights_path, quiet=False)
        print("Đã tải xong file trọng số!")
    else:
        print("File weights/best.pt đã sẵn sàng!")

# Gọi hàm này ngay khi file run.py bắt đầu chạy
check_and_download_weights()

def check_and_download_weights():
    """Hàm tự động kiểm tra và tải file weights từ Google Drive nếu chưa có"""
    weights_path = "weights/best.pt"
    
    if not os.path.exists(weights_path):
        print("Không tìm thấy weights/best.pt. Đang tự động tải về từ Google Drive...")
        os.makedirs("weights", exist_ok=True)
        
        # Thay mã FILE_ID của Vịt vào đây nhé
        file_id = "1red_fox" # Hoặc điền ID dài ngoằng của cậu vào đây
        url = f"https://drive.google.com/uc?id={file_id}"
        
        try:
            gdown.download(url, weights_path, quiet=False)
            print("Đã tải xong file trọng số từ Drive!")
        except Exception as e:
            print(f"Lỗi khi tải file từ Drive: {e}")
    else:
        print("File weights/best.pt đã sẵn sàng!")

def main():
    # 1. Định nghĩa các tham số truyền vào khi chạy từ Terminal (giống yêu cầu của anh ấy)
    parser = argparse.ArgumentParser(description="YOLOv8 Animal Detection Inference Script")
    parser.add_argument("--source", type=str, required=True, help="Đường dẫn tới file ảnh cần predict")
    args = parser.parse_args()
    
    # 2. Tự động kiểm tra và tải weights trước khi chạy
    check_and_download_weights()
    
    # 3. Khởi tạo mô hình nhận diện vật thể
    print(f"Đang nạp mô hình từ weights/best.pt...")
    model = YOLO("weights/best.pt")
    
    # 4. Tiến hành nhận diện bức ảnh được truyền vào qua tham số --source
    print(f"Đang tiến hành nhận diện ảnh: {args.source}")
    results = model(args.source)
    
    # 5. In kết quả ra màn hình log
    for r in results:
        print("--- KẾT QUẢ NHẬN DIỆN CỦA VỊT ---")
        # In tên các loài vật tìm thấy trong ảnh
        for box in r.boxes:
            class_id = int(box.cls)
            label = model.names[class_id]
            conf = float(box.conf)
            print(f"- Tìm thấy: {label} (Độ tin cậy: {conf:.2f})")

if __name__ == "__main__":
    main()
