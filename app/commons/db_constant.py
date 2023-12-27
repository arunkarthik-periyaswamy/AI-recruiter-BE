from app import db
from app.roles.role import Role

try:
    ROLE_ADMIN = Role.query.filter(Role.name == 'Admin').first()
    QUESTIONER_MANAGER = Role.query.filter(Role.name == 'Questioner manager').first()
    QUESTIONER = Role.query.filter(Role.name == 'Questioner').first()
    if not (QUESTIONER and QUESTIONER_MANAGER and ROLE_ADMIN):
        raise Exception("Roles not found in DB!.")
except Exception as e:
    raise e
finally:
    db.session.close()

