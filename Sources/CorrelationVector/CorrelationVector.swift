import Foundation

@objc public class CorrelationVector: NSObject, CorrelationVectorProtocol {
  internal static let delimiter: Character = "."
  internal static let terminator = "!"

  /// This is the header that should be used between services to pass the
  /// correlation vector.
  public static let headerName = "MS-CV";

  /// Gets or sets a value indicating whether or not to validate the correlation
  /// vector on creation.
  public static var validateDuringCreation = false

  private var implementation: CorrelationVectorProtocol

  public var value: String {
    return self.implementation.value
  }

  public var base: String {
    return self.implementation.base
  }

  public var `extension`: Int {
    return self.implementation.extension
  }

  public var version: CorrelationVectorVersion {
    return self.implementation.version
  }

  /// Initializes a new instance of the Correlation Vector with V1 implementation.
  /// This should only be called when no correlation vector was found in the
  /// message header.
  public required override convenience init() {
    self.init(.v1)
  }

  /// Initializes a new instance of the Correlation Vector of the V2 implementation
  /// using the given UUID as the vector base.
  ///
  /// - Parameter vectorBase: the UUID to use as a correlation vector base.
  public required convenience init(_ vectorBase: UUID) {
    self.init(CorrelationVectorV2.init(vectorBase))
  }

  /// Initializes a new instance of the Correlation Vector of the given
  /// implementation version. This should only be called when no correlation vector
  /// was found in the message header.
  ///
  /// - Parameter version: the Correlation Vector implementation version.
  public convenience init(_ version: CorrelationVectorVersion) {
    self.init(version.type.init())
  }

  private init(_ implementation: CorrelationVectorProtocol) {
    self.implementation = implementation
    super.init()
  }

  public func increment() -> String {
    return self.implementation.increment()
  }

  // TODO isEqual
  // TODO toString

  public static func parse(_ correlationVector: String?) -> CorrelationVectorProtocol {
    let version = CorrelationVectorVersion.infer(from: correlationVector)
    let instance = version.type.parse(correlationVector)
    return CorrelationVector(instance)
  }

  public static func extend(_ correlationVector: String?) -> CorrelationVectorProtocol {
    let version = CorrelationVectorVersion.infer(from: correlationVector)
    let instance = version.type.extend(correlationVector)
    return CorrelationVector(instance)
  }

  public static func spin(_ correlationVector: String?) -> CorrelationVectorProtocol {
    let version = CorrelationVectorVersion.infer(from: correlationVector)
    let instance = version.type.spin(correlationVector)
    return CorrelationVector(instance)
  }

  public static func spin(_ correlationVector: String?, _ parameters: SpinParameters) -> CorrelationVectorProtocol {
    let version = CorrelationVectorVersion.infer(from: correlationVector)
    let instance = version.type.spin(correlationVector, parameters)
    return CorrelationVector(instance)
  }
}
