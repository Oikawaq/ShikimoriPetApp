
import SnapKit
import UIKit

struct Segment {
    let value: Int
    let color: UIColor
    let label: String
}

final class SegmentedBar: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        stack.layer.cornerRadius = 8
        stack.clipsToBounds = true
        return stack
    }()
    private let container: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
        //MARK: init
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    
        //MARK: setupUI
    private func setupUI(){
        
        addSubview(container)
        container.addArrangedSubview(stackView)
        container.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
    }
    func configure(with segments: [Segment]){
        stackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
        let total = segments.reduce(0){$0 + $1.value}
        guard total > 0 else { return }
        
        
        segments.forEach{segment in
          
            let bar = UIView()
            bar.backgroundColor = segment.color
            stackView.addArrangedSubview(bar)
            let ratio = CGFloat(segment.value) / CGFloat(total)
            bar.snp.makeConstraints{make in
                make.width.equalTo(stackView).multipliedBy(ratio)
                make.height.equalTo(16)
            }
            let label = UILabel()
            label.text = segment.value.description
            label.font = .systemFont(ofSize: 12)
            bar.addSubview(label)
            label.snp.makeConstraints{
                $0.centerX.equalToSuperview()
            }
        }
    }

}
