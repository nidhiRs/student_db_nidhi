json.extract! student, :id, :full_name, :address, :email, :institution_id, :created_at, :updated_at
json.url student_url(student, format: :json)
