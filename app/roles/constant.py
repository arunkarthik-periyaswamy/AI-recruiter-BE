from app import db
from app.roles.role import Role

try:
    ROLE_ADMIN = Role.query.filter(Role.name == 'Admin').first()
except Exception as e:
    raise e
finally:
    db.session.close()

