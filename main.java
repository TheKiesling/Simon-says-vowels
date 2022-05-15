import java.util.Comparator;
import java.util.ArrayList;
import java.util.Arrays;

public class main{
	public static void main(String[] args){
		Ordenamientos<Integer> ord = new Ordenamientos<Integer>(new ComparadorEnteros<Integer>());
		long inicio, fin;
		Integer[] nums = {10, 9, 5, 2, 8, 3, 1, 1};

		System.out.println("\nArray: " + Arrays.toString(nums));

		//Quicksort

		System.out.println("\nQuickSort:");
		inicio = System.nanoTime();
		ord.quickSort(nums, 0, nums.length -1);
		fin = System.nanoTime()-inicio;

		System.out.println(Arrays.toString(nums));
		System.out.println("Tiempo: " + (double)fin/1000000000 + "s");

		resetArr(nums);

		//bubbleSort

		System.out.println("\nBubbleSort:");
		inicio = System.nanoTime();
		ord.bubbleSort(nums);
		fin = System.nanoTime()-inicio;

		System.out.println(Arrays.toString(nums));
		System.out.println("Tiempo: " + (double)fin/1000000000 + "s");

		resetArr(nums);

		//radixSort

		System.out.println("\nRadixSort:");
		inicio = System.nanoTime();
		ord.radixSort(nums, nums.length);
		fin = System.nanoTime()-inicio;

		System.out.println(Arrays.toString(nums));
		System.out.println("Tiempo: " + (double)fin/1000000000 + "s");

		resetArr(nums);

		//gnomeSort

		System.out.println("\nGnomeSort:");
		inicio = System.nanoTime();
		ord.gnomeSort(nums, nums.length);
		fin = System.nanoTime()-inicio;

		System.out.println(Arrays.toString(nums));
		System.out.println("Tiempo: " + (double)fin/1000000000 + "s");

		resetArr(nums);

		//mergeSort

		System.out.println("\nMergeSort:");
		inicio = System.nanoTime();
		ord.mergeSort(nums, nums.length);
		fin = System.nanoTime()-inicio;

		System.out.println(Arrays.toString(nums));
		System.out.println("Tiempo: " + (double)fin/1000000000 + "s");

		System.out.println();

	}

	public static Integer[] resetArr(Integer[] arr){
		arr[0] = 10;
		arr[1] = 9;
		arr[2] = 5;
		arr[3] = 2;
		arr[4] = 8;
		arr[5] = 3;
		arr[6] = 1;
		arr[7] = 1;
		return arr;
	}
}