from flask import Flask, jsonify, request, render_template
from flask_sqlalchemy import SQLAlchemy
import datetime
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://USER:PASSWORD@DB-URI/hello'
db = SQLAlchemy(app)

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String())
    birthday = db.Column(db.DateTime(), default=datetime.datetime.utcnow)

    def __init__(self, username, birthday):
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

with app.app_context():
    db.create_all()

@app.route('/hello/<username>', methods=['PUT', 'GET'])
def hello(username):
    if username.isalpha():
        if request.method == 'PUT':
            req = request.get_json(silent=True)
            birthday = datetime.datetime.strptime(req['dateOfBirthday'], '%Y-%m-%d')
            
            if birthday > datetime.datetime.today():
                return jsonify({'status': 'ERROR', 'message': 'Did you come from future?'}), 422
            else:
                user = User.query.filter_by(username=username).first()
                if user:
                    if user.birthday != birthday:
                        user.birthday = birthday
                        return jsonify({'status': 'OK', 'message': 'User {} has been updated'.format(username.capitalize())}), 200
                    else:
                        return jsonify({'status': 'ERROR', 'message': 'Cannot update user {}. same birthday'.format(username.capitalize())}), 422
                else:
                    user = User(username, birthday)
                    db.session.merge(user)
                    db.session.commit()

                    return jsonify(success=True), 204
        else:
            user = User.query.filter_by(username=username).first()
            if user:
                today = datetime.datetime.today().date()
                if (today - user.birthday.date()).days == 365:
                    return jsonify({'status': 'OK', 'message': 'Hello, {}! Happy birthday!'.format(user.username.capitalize())}), 200
                else:
                    birthday = user.birthday.replace(year = today.year, hour=0, minute=0, second=0).date()
                    if birthday > today:
                        days_to_birthday = (birthday - today).days
                    else:
                        if birthday.month > 2:
                            days_to_birthday = 365 + (birthday - today).days + 1
                        else:
                            days_to_birthday = 365 + (birthday - today).days
                    
                    return jsonify({'status': 'OK', 'message': 'Hello, {}! Your birthday is in {} days!'.format(user.username.capitalize(), days_to_birthday)}), 200
            else:
                return jsonify({'status': 'ERROR', 'message': 'Who are you?'}), 404

    else:
        return jsonify({'status': 'ERROR', 'message': 'Only letters accepted on username'}), 422

@app.route('/api/status', methods=['GET'])
def health_database_status():
    is_database_working = True

    try:
        # to check database we will execute raw query
        db.session.execute('SELECT 1')
    except Exception as e:
        is_database_working = False
    
    if is_database_working == True:
        return jsonify({'status': is_database_working), 200
    else:
        return jsonify({'status': is_database_working), 400
    
app.run(host='0.0.0.0', port=8000, debug=True)
