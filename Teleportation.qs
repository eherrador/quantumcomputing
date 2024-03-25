/// # Sample
/// Quantum Teleportation
///
/// # Description
/// Quantum teleportation provides a way of moving a quantum state from one
/// location to another without having to move physical particle(s) along with
/// it. This is done with the help of previously shared quantum entanglement
/// between the sending and the receiving locations, and classical
/// communication.
///
/// This Q# program implements quantum teleportation.
namespace Sample {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    @EntryPoint()
    operation Main () : Result[] {
        // Allocate the message and target qubits.
        use (message, target) = (Qubit(), Qubit());

        // Use the `Teleport` operation to send different quantum states.
        let stateInitializerBasisTuples = [
            ("|0〉", I, PauliZ),
            ("|1〉", X, PauliZ),
            ("|+〉", SetToPlus, PauliX),
            ("|-〉", SetToMinus, PauliX)
        ];

        mutable results = [];
        for (state, initializer, basis) in stateInitializerBasisTuples {
            // Initialize the message and show its state using the `DumpMachine`
            // function.
            initializer(message);
            Message($"Teleporting state {state}");
            DumpMachine();

            // Teleport the message and show the quantum state after
            // teleportation.
            Teleport(message, target);
            Message($"Received state {state}");
            DumpMachine();

            // Measure target in the corresponding basis and reset the qubits to
            // continue teleporting more messages.
            let result = Measure([basis], [target]);
            set results += [result];
            ResetAll([message, target]);
        }

        return results;
    }
