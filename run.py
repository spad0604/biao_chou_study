import os
import argparse
import gdown
from ultralytics import YOLO

def check_and_download_weights():
    """Hàm tự động kiểm tra và tải file weights từ Google Drive nếu chưa có"""
    weights_path = "weights/best.pt"
    
    # 1. Kiểm tra xem file best.pt đã tồn tại ở local chưa
    if not os.path.exists(weights_path):
        print("Không tìm thấy file trọng số weights/best.pt. Đang tự động tải về từ Google Drive...")
        
        # Tạo thư mục weights nếu chưa có
        os.makedirs("weights", exist_ok=True)
        
        # Mã FILE_ID chuẩn của Vịt
        file_id = "19v6iP7NAY90H9aD4QLZhVmMaWTmE26vY"
        url = f"https://drive.google.com/uc?id={file_id}"
        
        # 2. Tiến hành tải file từ Drive xuống và bắt lỗi nếu link die
        try:
            gdown.download(url, weights_path, quiet=False)
            print("Đã tải xong file trọng số từ Drive!")
        except Exception as e:
            print(f"Lỗi khi tải file từ Drive: {e}")
    else:
        print("File weights/best.pt đã sẵn sàng!")

def main():
    # 1. Định nghĩa các tham số truyền vào khi chạy từ Terminal (--source)
    parser = argparse.ArgumentParser(description="YOLOv8 Animal Detection Inference Script")
    parser.add_argument("--source", type=str, required=True, help="Đường dẫn tới file ảnh cần predict")
    args = parser.parse_args()
    
    # 2. Tự động kiểm tra và tải weights trước khi chạy mô hình
    check_and_download_weights()
    
    # 3. Khởi tạo mô hình nhận diện vật thể YOLOv8
    print(f"Đang nạp mô hình từ weights/best.pt...")
    model = YOLO("weights/best.pt")
    
    # 4. Tiến hành nhận diện bức ảnh được truyền vào
    print(f"Đang tiến hành nhận diện ảnh: {args.source}")
    results = model(args.source)
    
    # 5. In kết quả trực quan ra màn hình log
    for r in results:
        print("\n--- KẾT QUẢ NHẬN DIỆN CỦA VỊT ---")
        if len(r.boxes) == 0:
            print("- Không tìm thấy loài động vật nào trong ảnh.")
        else:
            for box in r.boxes:
                class_id = int(box.cls)
                label = model.names[class_id]
                conf = float(box.conf)
                print(f"- Tìm thấy: {label} (Độ tin cậy: {conf:.2f})")
        print("---------------------------------\n")

if __name__ == "__main__":
    main()
