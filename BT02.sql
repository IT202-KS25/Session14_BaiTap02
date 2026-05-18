DELIMITER //
CREATE PROCEDURE TransferBed (
    IN p_patient_id INT,
    IN p_new_bed_id INT
)
BEGIN
    START TRANSACTION;

    UPDATE Beds
    SET patient_id = NULL
    WHERE patient_id = p_patient_id;

    UPDATE Beds
    SET patient_id = p_patient_id
    WHERE bed_id = p_new_bed_id;

    COMMIT;

END //

DELIMITER ;

-- Việc bệnh nhân bị “mất tích” khỏi hệ thống (không nằm ở giường cũ cũng chưa được gán sang giường mới) đang vi phạm tính Atomicity (Tính nguyên tử) trong ACID. Vì quá trình chuyển 
-- giường phải được xem là một giao dịch thống nhất: hoặc hoàn thành toàn bộ, hoặc phải khôi phục lại trạng thái ban đầu nếu có lỗi.

-- SỬA:
DROP PROCEDURE IF EXISTS TransferBed;

DELIMITER //

CREATE PROCEDURE TransferBed (
    IN p_patient_id INT,
    IN p_new_bed_id INT
)
BEGIN
    START TRANSACTION;

    -- Thao tác 1: Giải phóng giường cũ
    UPDATE Beds
    SET patient_id = NULL
    WHERE patient_id = p_patient_id;

    -- Thao tác 2: Gán bệnh nhân vào giường mới
    UPDATE Beds
    SET patient_id = p_patient_id
    WHERE bed_id = p_new_bed_id;

    COMMIT;

END //

DELIMITER ;