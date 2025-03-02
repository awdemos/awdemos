def sieve_of_eratosthenes(limit):
    """
    Generates all prime numbers up to the given limit using the Sieve of Eratosthenes algorithm.

    Parameters:
    - limit (int): The upper limit for generating prime numbers.

    Returns:
    - list: A list of all prime numbers up to the limit.

    Raises:
    - ValueError: If the limit is not a positive integer.
    """

    if not isinstance(limit, int) or limit < 1:
        raise ValueError("Limit must be a positive integer.")

    primes = []
    is_prime = [True] * (limit + 1)
    is_prime[0] = is_prime[1] = False

    for number in range(2, int(limit**0.5) + 1):
        if is_prime[number]:
            primes.append(number)
            for multiple in range(number * number, limit + 1, number):
                is_prime[multiple] = False

    for number in range(int(limit**0.5) + 1, limit + 1):
        if is_prime[number]:
            primes.append(number)

    return primes

# Example usage
if __name__ == "__main__":
    limit = 50
    primes = sieve_of_eratosthenes(limit)
    print(f"Prime numbers up to {limit}:")
    print(primes)
    print(f"Total primes found: {len(primes)}")

