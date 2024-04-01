import math
from random import random_ui64

alias ACTUAL_PI = 3.141592653589793238462643383279
var max_random = 256**3
var max_iterations = 256**3


fn main():
    var count = 0
    var best_pi = 0.0
    var lowest_error = ACTUAL_PI
    for i in range(1, max_iterations):
        var pair = random_pair(max_random)
        var a = pair.get[0, UInt64]().to_int()
        var b = pair.get[1, UInt64]().to_int()

        # doesnt seem to be simdable??
        # relevant? https://onlinelibrary.wiley.com/doi/abs/10.1002/cpe.6270
        # nah
        if math.gcd(a, b) == 1:
            count += 1
        # print("C: " + String(count) + " I: " + String(i))

        if count > 0:
            var pi = pi_from_probability(count, i)
            var error = math.abs(pi - ACTUAL_PI)

            # print("[" + String(i) + "/" + String(max_iterations) + "]:")
            # print("Result: " + String(pi))
            # print("Error: " + String(error))

            if error < lowest_error:
                lowest_error = error
                best_pi = pi
    var accuracy = (lowest_error / ACTUAL_PI) * 100.0
    print(" Computed Pi: " + String(best_pi))
    print("   Actual Pi: " + String(ACTUAL_PI))
    print("")
    print("    Accuracy: " + String(accuracy))
    print("Lowest Error: " + String(lowest_error))


fn random_pair(max_random: UInt64) -> (UInt64, UInt64):
    var a = random_ui64(0, max_random)
    var b = random_ui64(0, max_random)
    return (a, b)


fn pi_from_probability(count: UInt64, iteration: UInt64) -> Float64:
    var c: Float64 = count.cast[DType.float64]() / iteration.cast[DType.float64]()
    var pi = math.sqrt(6.0 / c)
    return pi
