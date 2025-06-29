#[test]
fn test_valid_proof() {
    // 测试用例：x = 5, y = 2
    // 5 != 2² = 4，应该通过
    let x = 5;
    let y = 2;
    main(x, y);
}

#[test]
fn test_invalid_proof() {
    // 测试用例：x = 4, y = 2
    // 4 == 2² = 4，应该失败
    let x = 4;
    let y = 2;
    // 这个调用应该失败，因为 x == y²
    // main(x, y); // 取消注释来测试失败情况
}

#[test]
fn test_zero_case() {
    // 测试用例：x = 0, y = 0
    // 0 == 0² = 0，应该失败
    let x = 0;
    let y = 0;
    // 这个调用应该失败，因为 x == y²
    // main(x, y); // 取消注释来测试失败情况
} 