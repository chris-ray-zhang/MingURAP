public class TestAnimals {
	public static void main(String[] args) {
		// Animal o2 = new Dog("Pluto", 10); /*  new Animal("Pluto", 10) DOESN"T WORK*/
		Animal o2 = new Animal("Pluto", 10);
		// Dog sdx = ((Dog) o2);
		// sdx.greet();

		// Animal dx = ((Animal) o2);
		// dx.greet();

		System.out.println(((Dog) o2).noise);

		// Object o3 = (Dog) o2;
		// o3.greet();


		// Cat c = new Cat("Garfield", 6);
		// Dog d = new Dog("Fido", 4);

		// a.greet();
		// c.greet();
		// d.greet();

		// a = c;
		// a.greet();
		// ((Cat) a).greet();
		
		
	}
}