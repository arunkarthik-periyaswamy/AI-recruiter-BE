class CustomError(Exception):

    # Constructor or Initializer
    def __init__(self, msg, status_code):
        self.msg = msg
        self.status_code = status_code
    # __str__ is to print() the value
    def __str__(self):
        return (repr(self.msg))