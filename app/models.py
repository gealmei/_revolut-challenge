import datetime
from app import db

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String())
    birthday = db.Column(db.DateTime(), default=datetime.datetime.utcnow)

    def __init__(self, name, author, published):
        self.username = username
        self.birthday = birthday

    def __repr__(self):
        return '<id {}>'.format(self.id)
    
    def serialize(self):
        return {
            'id': self.id, 
            'username': self.username,
            'birthday': self.birthday,
        }
