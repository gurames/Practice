"""
Демонстрация работы методов базового и производного классов.
Пример: геометрические фигуры (Базовый класс - Фигура, Производные - Круг и Прямоугольник)
"""

import math
from abc import ABC, abstractmethod


# Базовый абстрактный класс
class Shape(ABC):
    """Базовый класс Фигура"""
    
    def __init__(self, name="Фигура"):
        self.name = name
        self._color = "белый"  # защищенный атрибут
    
    @abstractmethod
    def area(self):
        """Абстрактный метод для вычисления площади"""
        pass
    
    @abstractmethod
    def perimeter(self):
        """Абстрактный метод для вычисления периметра"""
        pass
    
    def get_name(self):
        """Метод базового класса для получения имени"""
        return self.name
    
    def set_color(self, color):
        """Метод базового класса для установки цвета"""
        self._color = color
        print(f"Цвет фигуры '{self.name}' изменен на {color}")
    
    def get_color(self):
        """Метод базового класса для получения цвета"""
        return self._color
    
    def display_info(self):
        """Метод базового класса для вывода информации"""
        return f"{self.get_name()} (цвет: {self.get_color()})"
    
    def __str__(self):
        return f"{self.name} (цвет: {self._color})"


# Производный класс - Круг
class Circle(Shape):
    """Класс Круг, производный от Shape"""
    
    def __init__(self, radius, name="Круг"):
        super().__init__(name)  # вызов конструктора базового класса
        self.radius = radius
        self._pi = math.pi  # дополнительный атрибут
    
    def area(self):
        """Переопределение метода area"""
        return self._pi * self.radius ** 2
    
    def perimeter(self):
        """Переопределение метода perimeter (длина окружности)"""
        return 2 * self._pi * self.radius
    
    def get_diameter(self):
        """Собственный метод класса Circle"""
        return 2 * self.radius
    
    def display_info(self):
        """Переопределение метода базового класса"""
        base_info = super().display_info()
        return f"{base_info}, радиус: {self.radius}, диаметр: {self.get_diameter()}"


# Производный класс - Прямоугольник
class Rectangle(Shape):
    """Класс Прямоугольник, производный от Shape"""
    
    def __init__(self, width, height, name="Прямоугольник"):
        super().__init__(name)  # вызов конструктора базового класса
        self.width = width
        self.height = height
    
    def area(self):
        """Переопределение метода area"""
        return self.width * self.height
    
    def perimeter(self):
        """Переопределение метода perimeter"""
        return 2 * (self.width + self.height)
    
    def is_square(self):
        """Собственный метод класса Rectangle"""
        return self.width == self.height
    
    def display_info(self):
        """Переопределение метода базового класса"""
        base_info = super().display_info()
        return f"{base_info}, ширина: {self.width}, высота: {self.height}"


# Производный класс - Треугольник (дополнительный пример)
class Triangle(Shape):
    """Класс Треугольник, производный от Shape"""
    
    def __init__(self, side_a, side_b, side_c, name="Треугольник"):
        super().__init__(name)
        self.side_a = side_a
        self.side_b = side_b
        self.side_c = side_c
    
    def area(self):
        """Переопределение метода area (формула Герона)"""
        s = self.perimeter() / 2
        return math.sqrt(s * (s - self.side_a) * (s - self.side_b) * (s - self.side_c))
    
    def perimeter(self):
        """Переопределение метода perimeter"""
        return self.side_a + self.side_b + self.side_c
    
    def is_equilateral(self):
        """Собственный метод класса Triangle"""
        return self.side_a == self.side_b == self.side_c
    
    def display_info(self):
        """Переопределение метода базового класса"""
        base_info = super().display_info()
        return f"{base_info}, стороны: {self.side_a}, {self.side_b}, {self.side_c}"


# Тестовая программа
def test_classes():
    """Тестовая функция для демонстрации работы методов"""
    
    print("=" * 60)
    print("ТЕСТОВАЯ ПРОГРАММА ДЛЯ ДЕМОНСТРАЦИИ РАБОТЫ МЕТОДОВ КЛАССОВ")
    print("=" * 60)
    
    # 1. Создание объектов
    print("\n1. СОЗДАНИЕ ОБЪЕКТОВ:")
    print("-" * 40)
    
    circle = Circle(radius=5, name="Мой круг")
    rectangle = Rectangle(width=4, height=6, name="Мой прямоугольник")
    triangle = Triangle(side_a=3, side_b=4, side_c=5, name="Мой треугольник")
    
    print(f"✓ Создан: {circle}")
    print(f"✓ Создан: {rectangle}")
    print(f"✓ Создан: {triangle}")
    
    # 2. Демонстрация методов базового класса
    print("\n2. МЕТОДЫ БАЗОВОГО КЛАССА (Shape):")
    print("-" * 40)
    
    print(f"circle.get_name() -> '{circle.get_name()}'")
    print(f"circle.get_color() -> '{circle.get_color()}'")
    circle.set_color("красный")
    print(f"circle.get_color() после изменения -> '{circle.get_color()}'")
    
    # 3. Демонстрация абстрактных методов (переопределенных в производных)
    print("\n3. ПЕРЕОПРЕДЕЛЕННЫЕ МЕТОДЫ (area, perimeter):")
    print("-" * 40)
    
    print(f"Круг: area = {circle.area():.2f}, perimeter = {circle.perimeter():.2f}")
    print(f"Прямоугольник: area = {rectangle.area():.2f}, perimeter = {rectangle.perimeter():.2f}")
    print(f"Треугольник: area = {triangle.area():.2f}, perimeter = {triangle.perimeter():.2f}")
    
    # 4. Демонстрация собственных методов производных классов
    print("\n4. СОБСТВЕННЫЕ МЕТОДЫ ПРОИЗВОДНЫХ КЛАССОВ:")
    print("-" * 40)
    
    print(f"circle.get_diameter() -> {circle.get_diameter():.2f}")
    print(f"rectangle.is_square() -> {rectangle.is_square()} (ширина: {rectangle.width}, высота: {rectangle.height})")
    print(f"triangle.is_equilateral() -> {triangle.is_equilateral()} (стороны: {triangle.side_a}, {triangle.side_b}, {triangle.side_c})")
    
    # 5. Демонстрация переопределенного метода display_info
    print("\n5. ПЕРЕОПРЕДЕЛЕННЫЙ МЕТОД display_info():")
    print("-" * 40)
    
    print(f"circle.display_info() -> {circle.display_info()}")
    print(f"rectangle.display_info() -> {rectangle.display_info()}")
    print(f"triangle.display_info() -> {triangle.display_info()}")
    
    # 6. Демонстрация полиморфизма
    print("\n6. ПОЛИМОРФИЗМ (обработка объектов через базовый класс):")
    print("-" * 40)
    
    shapes = [circle, rectangle, triangle]
    for shape in shapes:
        print(f"{shape.get_name()}: площадь = {shape.area():.2f}, периметр = {shape.perimeter():.2f}")
    
    # 7. Демонстрация работы с атрибутами
    print("\n7. ДОСТУП К АТРИБУТАМ:")
    print("-" * 40)
    
    print(f"circle.radius = {circle.radius} (публичный атрибут)")
    print(f"circle._color = '{circle._color}' (защищенный атрибут)")
    print(f"circle._pi = {circle._pi:.5f} (приватный по соглашению атрибут)")
    
    # 8. Использование встроенных методов
    print("\n8. ВСТРОЕННЫЕ МЕТОДЫ (__str__):")
    print("-" * 40)
    
    print(f"str(circle) -> '{str(circle)}'")
    print(f"str(rectangle) -> '{str(rectangle)}'")
    print(f"str(triangle) -> '{str(triangle)}'")


# Запуск тестовой программы
if __name__ == "__main__":
    test_classes()
    
    print("\n" + "=" * 60)
    print("ТЕСТИРОВАНИЕ ЗАВЕРШЕНО УСПЕШНО!")
    print("=" * 60)