
import SnapKit
import UIKit

struct Segment {
    let value: Int
    let color: UIColor
    let status: WatchingStatus
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
    let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .basalt
        label.font = .systemFont(ofSize: 12)
        label.isUserInteractionEnabled = true
        return label
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
        container.addArrangedSubview(label)
        container.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        label.snp.makeConstraints{
            $0.top.equalTo(stackView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
    func configure(with segments: [Segment],description: String){
        
        stackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
        let total = segments.reduce(0){$0 + $1.value}
        guard total > 0 else { return }
        
        label.text = description
        
        segments.forEach{segment in
            
            let bar = UIView()
            bar.backgroundColor = segment.color
            stackView.addArrangedSubview(bar)
            let ratio = CGFloat(segment.value) / CGFloat(total)
            bar.snp.makeConstraints{make in
                make.width.equalTo(stackView).multipliedBy(ratio)
                make.height.equalTo(16)
            }
            let count = UILabel()
            if segment.value < 10{
                count.text = ""
            }else{
                count.text = segment.value.description
            }
            count.font = .systemFont(ofSize: 12)
            bar.addSubview(count)
            count.snp.makeConstraints{
                $0.centerX.equalToSuperview()
            }
        }
    }

}
