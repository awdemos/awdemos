use ndarray::{Array2, ArrayBase, Data, Ix2};

fn create_matrix(rows: usize, cols: usize, data: Vec<f64>) -> Array2<f64> {
    Array2::from_shape_vec((rows, cols), data).expect("Matrix creation failed")
}

fn print_matrix(matrix: &Array2<f64>) {
    for row in matrix.rows() {
        for val in row {
            print!("{:.2} ", val);
        }
        println!();
    }
}

fn main() {
    // Create two example matrices
    let matrix_a = create_matrix(2, 3, vec![1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
    let matrix_b = create_matrix(3, 2, vec![7.0, 8.0, 9.0, 10.0, 11.0, 12.0]);

    println!("Matrix A:");
    print_matrix(&matrix_a);
    println!("Matrix B:");
    print_matrix(&matrix_b);

    // Perform matrix multiplication
    if matrix_a.ncols() == matrix_b.nrows() {
        let result = matrix_a.dot(&matrix_b);
        println!("Result of A * B:");
        print_matrix(&result);
    } else {
        println!("Matrices cannot be multiplied");
    }
}

