# Cria (ou atualiza) o administrador da área de gestão.
# Em produção defina ADMIN_EMAIL e ADMIN_PASSWORD antes de correr `rails db:seed`.
admin_email = ENV.fetch("ADMIN_EMAIL", "marco@andreiaemarco.pt")
admin_password = ENV.fetch("ADMIN_PASSWORD", "AndreiaMarco2026!")

admin = Admin.find_or_initialize_by(email: admin_email)
admin.password = admin_password
admin.save!

puts "Administrador disponível: #{admin.email}"
