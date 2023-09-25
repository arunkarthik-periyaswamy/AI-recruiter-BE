from abc import ABC, abstractmethod


class ServiceABC(ABC):
    """Service ABC"""
    
    @abstractmethod
    def read(self):
        pass

    @abstractmethod
    def create(self):
        pass

    @abstractmethod
    def update(self):
        pass

    @abstractmethod
    def delete(self):
        pass
