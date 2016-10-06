// mark: -
// mark: PageWireframeDelegate protocol

protocol PageWireframeDelegate: class {
    func pageWireframeDidFinish(_ wireframe: PageWireframe)
}

// mark: -
// mark: PageWireframe class

final class PageWireframe {

    // mark: Properties

    fileprivate let presenter: PagePresenterInterface
    fileprivate var presentedViewController: UIViewController?
    fileprivate weak var delegate: PageWireframeDelegate?

    // mark: Init methods

    init(delegate: PageWireframeDelegate, presenter: PagePresenterInterface = PagePresenter()) {
        self.delegate = delegate
        self.presenter = presenter
        presenter.wireframe = self
    }

    // mark: Internal methods

    func presentFromViewController(_ presentingViewController: UIViewController?,
                                   withSearchTerm searchTerm: String?,
                                                  remoteURL: URL,
                                                  id: String) {
        let sb = UIStoryboard(name: "Page", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PageViewController
        vc.delegate = presenter
        presenter.configureUserInterfaceForPresentation(vc,
                                                        withSearchTerm: searchTerm,
                                                        remoteDownloadURL: remoteURL,
                                                        id: id)
        presentingViewController?.present(vc, animated: true, completion: nil)

        presentedViewController = vc

    }

    func showShareScreenWithImage(_ image: UIImage?) {
        if let image = image {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            presentedViewController?.present(vc, animated: true, completion: nil)
        }
    }

    func dismissPageScreen() {
        presentedViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.delegate?.pageWireframeDidFinish(self)
        })
    }
}
