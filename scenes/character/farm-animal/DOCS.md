## Sơ đồ state machine
- IDLE
    - On Next Marker
    - On Next Trough
    - On Random Direction
- Traveling
    - Place Marker
        - Return travel
        - Moved Trough
    - Travel
        - Return IDLE
    - Navigation Finished
- Eating

### Sau mỗi lần cập nhật state:
Kiểm tra HP
- Nếu HP <= 10:
    - Send event `food_marker_setted`
    - khi `food_marker_setted` được gửi, thực hiện hành động di chuyển đến `Trough` ở hàm
    `_on_place_marker_state_entered()`
    - khi di chuyển đến `Trough`, send event `trough_detected`(`_on_eating_state_entered` được gọi)
- Ngược lại, di chuyển đến target tiếp, hoặc random
