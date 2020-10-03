lint-autocorrect:
	swiftlint autocorrect

lint:
	swiftlint lint

check-format:
	swiftformat --lint Sources

generate-lcov:
	xcrun llvm-cov export -format="lcov" .build/debug/AEPRulesEnginePackageTests.xctest/Contents/MacOS/AEPRulesEnginePackageTests -instr-profile .build/debug/codecov/default.profdata > info.lcov