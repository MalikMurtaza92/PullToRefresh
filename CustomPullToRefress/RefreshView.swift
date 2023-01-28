//
//  RefreshView.swift
//  CustomPullToRefress
//
//  Created by Murtaza Mehmood on 29/01/2023.
//

import UIKit

protocol RefreshViewDelegate: NSObject {
    func beginRefresh(_ refresh: RefreshView)
}

class RefreshView: UIView, UIScrollViewDelegate {
    
    struct Constant {
        static var heightWhileRefresh: CGFloat = 50.0
        static var labelTopPadding: CGFloat = 10
        static var firstImage = UIImage(named: "PullRefresh-One")!
        static var secondImage = UIImage(named: "PullRefresh-Two")!
        static var ThirdImage = UIImage(named: "PullRefresh-Three")!
        static var labelTextBeforeRefreshing = "Pull down to refresh"
        static var labelTextWhileRefreshing = "Refreshing data"
    }
    
    //MARK: - PROPERTIES
    private let scrollView: UIScrollView!
    private var refreshLabel: UILabel!
    private var stackTopAnchor: NSLayoutConstraint!
    private var pullImage: UIImageView!
    private var stackView: UIStackView!
    private var isRefreshing: Bool = false
    private var activityIndicator: UIActivityIndicatorView!
    
    private var progress: CGFloat = 0.0
    
    weak var delegate: RefreshViewDelegate?
    
    init(frame: CGRect,scroll: UIScrollView) {
        self.scrollView = scroll
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor(red: 0.945, green: 0.949, blue: 0.945, alpha: 1)
        
        let separatorView = UIView()
        self.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(red: 0.741, green: 0.745, blue: 0.749, alpha: 1)
        
        refreshLabel = UILabel()
        self.addSubview(refreshLabel)
        refreshLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshLabel.text = Constant.labelTextBeforeRefreshing
        refreshLabel.sizeToFit()
        refreshLabel.font = UIFont.systemFont(ofSize: 14)
        refreshLabel.textColor = UIColor(red: 0.388, green: 0.4, blue: 0.416, alpha: 1)
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        
        addSubview(stackView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.isHidden = true
        
        stackTopAnchor = stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        stackTopAnchor.isActive = true
        
        pullImage = UIImageView()
        pullImage.translatesAutoresizingMaskIntoConstraints = false
        pullImage.image = Constant.firstImage
        
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(pullImage)
        stackView.addArrangedSubview(refreshLabel)
        
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pullImage.heightAnchor.constraint(equalToConstant: 24),
            pullImage.widthAnchor.constraint(equalToConstant: 24),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = max(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0.0)
        let space = min(self.bounds.height - offsetY,self.bounds.height)
        progress = min(max(offsetY / frame.size.height, 0.0), 1.0)
        
        guard !isRefreshing else {return}
        if space <= 0 {
            stackTopAnchor.constant = Constant.labelTopPadding
            pullImage.image = Constant.ThirdImage
        } else {
            stackTopAnchor.constant = space + Constant.labelTopPadding
            if progress > 0.25 && progress < 0.5{
                pullImage.image = Constant.firstImage
            } else if progress > 0.5 && progress < 0.75 {
                pullImage.image = Constant.secondImage
            }
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && self.progress >= 1.0 {
            delegate?.beginRefresh(self)
            startRefresh()
        }
    }
    
    func endRefreshing() {
        UIView.animate(withDuration: 0.3, delay:0.0, options: .curveEaseOut,
          animations: { [unowned self] in
            var newInsets = self.scrollView.contentInset
            newInsets.top -= Constant.heightWhileRefresh
            self.scrollView.contentInset = newInsets
          },
          completion: {[unowned self ] _ in
            self.refreshLabel.text = Constant.labelTextBeforeRefreshing
            self.isRefreshing = false
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.pullImage.isHidden = false
          }
        )
    }
    
    func startRefresh() {
        refreshLabel.text = Constant.labelTextWhileRefreshing
        isRefreshing = true
        
        UIView.animate(withDuration: 0.3, delay:0.0, options: .curveEaseOut,
          animations: { [unowned self] in
            var newInsets = self.scrollView.contentInset
            newInsets.top += Constant.heightWhileRefresh
            self.scrollView.contentInset = newInsets
          },
          completion: {[unowned self ]_ in
            self.stackTopAnchor.constant =  (((self.bounds.height - Constant.heightWhileRefresh) + self.bounds.height) / 2) - (stackView.bounds.height / 2)
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.pullImage.isHidden = true
            self.pullImage.image = Constant.firstImage
          }
        )
    }
}
